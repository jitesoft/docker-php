# syntax=docker/dockerfile:experimental
FROM registry.gitlab.com/jitesoft/dockerfiles/alpine:3.14
ARG PHP_VERSION
ARG BUILD_TYPE
ARG TARGETARCH
ARG BUILD_TIME
ARG PHP_MINOR

LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/php/issues" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.app.php.version="${PHP_VERSION}" \
      com.jitesoft.app.php.type="${BUILD_TYPE}" \
      # Open container labels
      org.opencontainers.image.version="${PHP_VERSION}" \
      org.opencontainers.image.created="${BUILD_TIME}" \
      org.opencontainers.image.description="PHP on alpine linux" \
      org.opencontainers.image.vendor="Jitesoft" \
      org.opencontainers.image.source="https://gitlab.com/jitesoft/dockerfiles/php" \
      # Artifact hub annotations
      io.artifacthub.package.alternative-locations="oci://registry.gitlab.com/jitesoft/dockerfiles/php/${BUILD_TYPE},oci://index.docker.io/jitesoft/php,oci://ghcr.io/jitesoft/php" \
      io.artifacthub.package.readme-url="https://gitlab.com/jitesoft/dockerfiles/php/-/raw/master/README.md" \
      io.artifacthub.package.logo-url="https://jitesoft.com/favicon-96x96.png"

ENV PHP_INI_DIR="/usr/local/etc/php" \
    PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c" \
    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
    PHP_SRC_DIR="/usr/src"

ARG WWWDATA_GUID="82"
ARG PHP_VERSION
ARG BUILD_TYPE
ARG TARGETARCH

ENV WWWDATA_GUID="${WWWDATA_GUID}"

RUN --mount=type=bind,source=./binaries,target=/tmp/php-bin \
    apk add --virtual .phpize-deps $PHPIZE_DEPS \
 && mkdir -p /var/www/html /usr/local/etc/php/conf.d /usr/src \
 && apk add --no-cache --virtual .runtime-deps ca-certificates musl curl tar openssl xz \
 && tar -xzhf /tmp/php-bin/php-${TARGETARCH}-${BUILD_TYPE}.tar.gz -C /usr/local \
 && cp /tmp/php-bin/php.tar.xz /usr/src/php.tar.xz \
 && mv /usr/local/php.ini-* /usr/local/etc/php/ \
 && adduser -u ${WWWDATA_GUID} -D -S -G www-data www-data \
 && chown www-data:www-data /var/www/html \
 && chmod 777 /var/www/html \
 && runDeps="$( \
      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
 && apk add --no-cache $runDeps \
 && pecl update-channels \
 && rm -rf /tmp/pear ~/.pearrc \
 && cd /usr/local/etc \
 && if [ "${BUILD_TYPE}" == "fpm" ]; then \
      sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
      cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
      echo $'[global] \nerror_log = /proc/self/fd/2\nlog_limit = 8192 \n[www]\naccess.log = /proc/self/fd/1\nclear_env = no\ncatch_workers_output = yes\ndecorate_workers_output = no\n' >> php-fpm.d/docker.conf; \
      echo $'[global]\ndaemonize = no\n[www]\nlisten = 9000\n' >> php-fpm.d/zz-docker.conf; \
      apk add --no-cache fcgi; \
   fi \
 && chmod -R +x /usr/local/bin \
 && apk del .phpize-deps \
 && php -version

STOPSIGNAL SIGQUIT
WORKDIR /var/www/html
ENTRYPOINT ["entrypoint"]
