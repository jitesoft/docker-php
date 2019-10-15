# syntax = docker/dockerfile:experimental
FROM --platform=$BUILDPLATFORM cross-test AS compile
ARG BUILD_TYPE

ENV PKG_CONFIG_SYSROOT_DIR="/usr/${GNU_TRIPLET}" \
    PHP_INI_DIR="/usr/local/etc/php" \
    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
    SYSROOT="/usr/${GNU_TRIPLET}"

COPY ./php.tar.xz /usr/${GNU_TRIPLET}/usr/src/php.tar.xz
COPY ./zlib.tar.gz /tmp/zlib.tar.gz

RUN mkdir -p ${SYSROOT}/usr/src/php \
 && apk add --no-cache re2c bison \
 && apk add --no-cache \
      --repositories-file /etc/apk/repositories \
      --keys-dir /etc/apk/keys \
      --initdb \
      --prefix=usr \
      --allow-untrusted \
      --root /usr/${GNU_TRIPLET} \
      --arch ${GNU_ARCH} \
      --virtual .build-deps curl-dev libsodium-dev argon2-dev libxml2-dev openssl-dev sqlite-dev libc-dev dpkg-dev libedit-dev readline-dev zlib-dev

#ENV CFLAGS="${PHP_CFLAGS}"  \
#    CC="${CC} -H" \
#    CXX="${CXX}" \
#    LD="${LD}" \
#    INCLUDES="-I/include -I/usr/include -I/usr/include/editline -I${SYSROOT}/usr/include -I${SYSROOT}/include -I${SYSROOT}/usr/include/editline"
ENV CC="${CC} -I/include -I/usr/include -I/usr/include/editline" \
    CXX="${CXX} -I${SYSROOT}/include -I${SYSROOT}/usr/include -I${SYSROOT}/usr/include/editline"


RUN tar -Jhxf ${SYSROOT}/usr/src/php.tar.xz -C ${SYSROOT}/usr/src/php --strip-components=1 \
 && dpkg --add-architecture ${GNU_ARCH}

RUN addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && PHP_EXTRA_CONFIGURE_ARGS=$([ "${BUILD_TYPE}" == "fpm" ] && echo "--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi" || echo "") \
# && sed -i 's~/@HOST_MULTIARCH@~~' ${SYSROOT}/usr/lib/pkgconfig/libargon2.pc \
 && cd ${SYSROOT}/usr/src/php \
# && LIBRARY_PATH="${LIBRARY_PATH}:/lib:/usr/lib:${SYSROOT}/lib:${SYSROOT}/usr/lib" \
#    CPATH="${CPATH}:/include:/usr/include/editline:${SYSROOT}/usr/include:${SYSROOT}/usr/include/editline" \
 &&    ./configure \
      --prefix=/usr/local \
      --build="x86_64-linux-musl" \
      --host="${GNU_TRIPLET}" \
      --with-config-file-path=/usr/local/etc/php \
      --with-config-file-scan-dir=/usr/local/etc/php/conf.d \
      --enable-option-checking=fatal \
      --with-mhash \
      --with-pcre-regex \
      --with-libedit \
      --with-openssl \
      --with-openssl-dir=/usr \
      --with-sodium=shared \
      --with-password-argon2 \
      --with-libxml-dir \
      --with-mysqli \
     # --with-zlib \
      --with-curl \
      --enable-calendar \
      --enable-ftp \
      --enable-exif \
      --enable-mbstring \
      --enable-mysqlnd \
      ${PHP_EXTRA_CONFIGURE_ARGS} || echo "whoops..."
# && make -j4 -i -l V= | awk 'NR%20==0 {print NR,$0}' \
# && find -type f -name '*.a' -delete
#FROM registry.gitlab.com/jitesoft/dockerfiles/alpine:latest
#ARG PHP_VERSION
#ARG BUILD_TYPE
#LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
#      maintainer.org="Jitesoft" \
#      maintainer.org.uri="https://jitesoft.com" \
#      com.jitesoft.project.repo.type="git" \
#      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/php" \
#      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/php/issues" \
#      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/php" \
#      com.jitesoft.app.php.version="${PHP_VERSION}" \
#      com.jitesoft.app.php.type="${BUILD_TYPE}"
#ENV PHP_INI_DIR="/usr/local/etc/php" \
#    PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c" \
#    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
#    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
#    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

#COPY ./scripts/* /usr/local/bin/
#COPY --from=compile /usr/src/php /usr/src/php

#RUN mkdir -p /var/www/html /usr/local/etc/php/conf.d \
# && apk add --virtual .build-deps argon2-dev curl-dev libedit-dev libsodium-dev libxml2-dev openssl-dev sqlite-dev re2c libc-dev dpkg-dev zlib-dev $PHPIZE_DEPS \
# && cd /usr/src/php \
# && make install \
# && make clean \
# && apk del .build-deps \
# && cp -v php.ini-* "/usr/local/etc/php/" \
# && rm -rf /usr/src/php \
# && apk add --no-cache --virtual .runtime-deps ca-certificates curl tar openssl xz \
# && addgroup -g 82 -S www-data \
# && adduser -u 82 -D -S -G www-data www-data \
# && chown www-data:www-data /var/www/html \
# && chmod 777 /var/www/html \
# && { find /usr/local/bin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
# && runDeps="$( \
#      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
#      | tr ',' '\n' \
#      | sort -u \
#      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
#    )" \
# && apk add --no-cache $runDeps \
# && pecl update-channels \
# && rm -rf /tmp/pear ~/.pearrc \
# && cd /usr/local/etc \
# && if [ "${BUILD_TYPE}" == "fpm" ]; then \
#      echo "Is FPM build."; \
#      sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
#      cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
#      echo $'[global] \nerror_log = /proc/self/fd/2\nlog_limit = 8192 \n[www]\naccess.log = /proc/self/fd/2\nclear_env = no\ncatch_workers_output = yes\ndecorate_workers_output = no\n' >> php-fpm.d/docker.conf; \
#      echo $'[global]\ndaemonize = no\n[www]\nlisten = 9000\n' >> php-fpm.d/zz-docker.conf; \
#   fi \
# # To make sure that all scripts are possible to run even if file is commited with invalid access rights.
# && chmod -R +x /usr/local/bin \
# # Sanity check...
# && php -version

#STOPSIGNAL SIGQUIT
#WORKDIR /var/www/html
#ENTRYPOINT ["entrypoint"]
