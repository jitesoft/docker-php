# syntax = docker/dockerfile:experimental
FROM --platform=$BUILDPLATFORM registry.gitlab.com/jitesoft/dockerfiles/cross-compile:${TARGETARCH} AS compile

ENV PHP_INI_DIR="/usr/local/etc/php" \
    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ARG BUILD_TYPE
ARG TARGETARCH

COPY ./php.tar.xz /usr/src/php.tar.xz

RUN mkdir -p /usr/local/etc/php/conf.d /var/www/html /usr/src/php /tmp/php \
 && cd /usr/src/php \
 && apk add --no-cache --virtual .build-deps make argon2-dev curl-dev libedit-dev libsodium-dev libxml2-dev openssl-dev sqlite-dev re2c pkgconf libc-dev file dpkg-dev dpkg autoconf zlib-dev \
 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && tar -Jxf /usr/src/php.tar.xz -C /usr/src/php --strip-components=1 \
 && PHP_EXTRA_CONFIGURE_ARGS=$([ "${BUILD_TYPE}" == "fpm" ] && echo "--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi" || echo "") \
 && TARGET_ARCH=$([ "${TARGETARCH}" == "arm64" ] && echo "aarch64" || echo "${TARGETARCH}") \
 && ./configure \
    --prefix=/tmp/php \
    --build="amd64-linux-musl" \
    --host="${TARGET_ARCH}-linux-musl" \
    --with-config-file-path="/usr/local/etc/php" \
    --with-config-file-scan-dir="/usr/local/etc/php/conf.d" \
    --enable-option-checking=fatal \
    --with-mhash --enable-ftp --enable-mbstring --enable-mysqlnd \
    --with-password-argon2 --with-sodium --with-curl --with-libedit \
    --with-openssl --with-zlib ${PHP_EXTRA_CONFIGURE_ARGS} \
 && make -j4 -i -l V= | awk 'NR%20==0 {print NR,$0}' \
 && find -type f -name '*.a' -delete \
 && make install \
 && make clean \
 && cp -v php.ini-* "/usr/local/etc/php/"

FROM registry.gitlab.com/jitesoft/dockerfiles/alpine:latest
ARG PHP_VERSION
ARG BUILD_TYPE
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/php/issues" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.app.php.version="${PHP_VERSION}" \
      com.jitesoft.app.php.type="${BUILD_TYPE}"

ENV PHP_INI_DIR="/usr/local/etc/php" \
    PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c" \
    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

COPY ./scripts/* /usr/local/bin/
COPY --from=compile /tmp/php /usr/local
COPY --from=compile /usr/local/etc/php /usr/local/etc/php
COPY --from=compile /usr/src/php.tar.xz /usr/src/php.tar.xz

RUN mkdir -p /var/www/html \
 && apk add --no-cache --virtual .runtime-deps ca-certificates curl tar openssl xz \
 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && chown www-data:www-data /var/www/html \
 && chmod 777 /var/www/html \
 && { find /usr/local/bin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 && runDeps="$( \
      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
 && apk add --no-cache $runDeps \
 && pecl update-channels \
 && rm -rf /tmp/pear ~/.pearrc \
 && cd /usr/local/etc \
 && if [ "${BUILD_TYPE}" == "fpm" ]; then \
      echo "Is FPM build."; \
      sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
      cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
      echo $'[global] \nerror_log = /proc/self/fd/2\nlog_limit = 8192 \n[www]\naccess.log = /proc/self/fd/2\nclear_env = no\ncatch_workers_output = yes\ndecorate_workers_output = no\n' >> php-fpm.d/docker.conf; \
      echo $'[global]\ndaemonize = no\n[www]\nlisten = 9000\n' >> php-fpm.d/zz-docker.conf; \
   fi \
 # To make sure that all scripts are possible to run even if file is commited with invalid access rights.
 && chmod -R +x /usr/local/bin \
 # Sanity check...
 && php -version

STOPSIGNAL SIGQUIT
WORKDIR /var/www/html
ENTRYPOINT ["entrypoint"]
