ARG PHP_VERSION="7.3.6"
ARG BUILD_TYPE
ARG EXTRA_PHP_ARGS
FROM registry.gitlab.com/jitesoft/dockerfiles/alpine:latest
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
    PHP_URI="https://www.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror" \
    PHP_ASC_URI="https://www.php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror" \
    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
    PHP_EXTRA_CONFIGURE_ARGS="${EXTRA_PHP_ARGS}"

COPY ./php.tar.xz /usr/src/php.tar.xz
COPY ./scripts/* /usr/local/bin/

RUN mkdir -p /usr/local/etc/php/conf.d /var/www/html /usr/src/php \
 && cd /usr/src/php \
 && apk add --no-cache --virtual .build-deps gnupg argon2-dev coreutils curl-dev libedit-dev libsodium-dev libxml2-dev openssl-dev sqlite-dev $PHPIZE_DEPS \
 && apk add --no-cache --virtual .runtime-deps ca-certificates curl tar openssl xz \
 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && chown www-data:www-data /var/www/html \
 && chmod 777 /var/www/html \
 && tar -Jxf /usr/src/php.tar.xz -C /usr/src/php --strip-components=1 \
 && ./configure \
    --build="x86_64-linux-musl" \
    --with-config-file-path="${PHP_INI_DIR}" \
    --with-config-file-scan-dir="${PHP_INI_DIR}/conf.d" \
    --enable-option-checking=fatal \
    --with-mhash --enable-ftp --enable-mbstring --enable-mysqlnd \
    --with-password-argon2 --with-sodium --with-curl --with-libedit \
    --with-openssl --with-zlib ${EXTRA_PHP_ARGS} \
 && make -j2 -i -l V= 2>/dev/null | awk 'NR%20==0 {print NR,$0}' \
 && find -type f -name '*.a' -delete \
 && make install \
 && { find /usr/local/bin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 && make clean \
 && cp -v php.ini-* "${PHP_INI_DIR}/" \
 && cd / \
 && rm -rf /usr/src/php \
 && runDeps="$( \
      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
 && apk add --no-cache $runDeps \
 && apk del .build-deps \
 && pecl update-channels \
 && rm -rf /tmp/pear ~/.pearrc \
 && cd /usr/local/etc \
 && if [ "${BUILD_TYPE}" == "fpm" ]; then \
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
EXPOSE 9000
ENTRYPOINT ["entrypoint"]
CMD ["php", "-a"]
