ARG PHP_VERSION
ARG BUILD_TYPE
FROM registry.gitlab.com/jitesoft/dockerfiles/php/${PHP_TYPE}:${PHP_VERSION}
LABEL maintainer="Johannes Tegnér <johannes@jitesoft.com>" \
      maintainer.org="Jitesoft" \
      maintainer.org.uri="https://jitesoft.com" \
      com.jitesoft.project.repo.type="git" \
      com.jitesoft.project.repo.uri="https://gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.project.repo.issues="https://gitlab.com/jitesoft/dockerfiles/php/issues" \
      com.jitesoft.project.registry.uri="registry.gitlab.com/jitesoft/dockerfiles/php" \
      com.jitesoft.project.app.php.variant="runtime"

RUN apk add --no-cache --virtual .build-deps coreutils $PHPIZE_DEPS \
    gmp-dev gd-dev libpng-dev libjpeg-turbo-dev libwebp-dev libzip-dev imagemagick-dev file \
 && printf "no\n" | pecl install redis \
 && printf "no\n" | pecl install imagick \
 && php-ext configure gd --with-jpeg --with-webp \
 && php-ext install gmp zip gd \
 && php-ext enable redis imagick \
 && apk del .build-deps \
 && apk add --no-cache --virtual .runtime gd gmp freetype libltdl libzip libwebp xz libjpeg-turbo libpng file imagemagick
