ARG PHP_VERSION
ARG PHP_TYPE
ARG BUILD_TIME

FROM registry.gitlab.com/jitesoft/dockerfiles/php/${PHP_TYPE}:${PHP_VERSION}
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/php/issues" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/php/runtime/${PHP_TYPE}" \
      com.jitesoft.project.app.php.variant="runtime"
      # Open container labels
      org.opencontainers.image.version="${PHP_VERSION}" \
      org.opencontainers.image.created="${BUILD_TIME}" \
      org.opencontainers.image.description="PHP ${PHP_TYPE} ${PHP_MINOR} on alpine linux with aditional runtime packages" \
      org.opencontainers.image.vendor="Jitesoft" \
      org.opencontainers.image.source="https://gitlab.com/jitesoft/dockerfiles/php" \
      # Artifact hub annotations
      io.artifacthub.package.alternative-locations="oci://registry.gitlab.com/jitesoft/dockerfiles/php/runtime/${PHP_TYPE},oci://index.docker.io/jitesoft/php,oci://ghcr.io/jitesoft/php" \
      io.artifacthub.package.readme-url="https://gitlab.com/jitesoft/dockerfiles/php/-/raw/master/README.md" \
      io.artifacthub.package.logo-url="https://jitesoft.com/favicon-96x96.png"


RUN apk add --no-cache --virtual .build-deps coreutils $PHPIZE_DEPS \
    gmp-dev gd-dev libpng-dev libjpeg-turbo-dev libwebp-dev libzip-dev imagemagick-dev file \
 && printf "no\n" | pecl install redis \
 && printf "no\n" | pecl install imagick \
 && php-ext configure gd --with-jpeg --with-webp \
 && php-ext install gmp zip gd \
 && php-ext enable redis imagick \
 && apk del .build-deps \
 && apk add --no-cache --virtual .runtime gd gmp freetype libltdl libzip libgomp libwebp xz libjpeg-turbo libpng file imagemagick
