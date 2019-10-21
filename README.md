# PHP

[![Docker Pulls](https://img.shields.io/docker/pulls/jitesoft/php.svg)](https://hub.docker.com/r/jitesoft/php)
[![Back project](https://img.shields.io/badge/Open%20Collective-Tip%20the%20devs!-blue.svg)](https://opencollective.com/jitesoft-open-source)

This image contains php built from source for the alpine linux distro.  

For now, the same commands as the official docker php image can be used for extensions (`docker-php-ext-enable`), these have also been added to
a shell script allowing for usage in the following format: `php-ext <command>` and are at the moment seen as deprecated (while no error will be produced still).

As you might notice, a lot of the extension scripts in the source is borrowed from the official PHP repository.  
This is temporary and will change in the future.

## Tags:

Sources are built natively on x86_64 and aarch64 and images built as cross-architecture builds with buildx.  
That is, the images are built for both amd64 and arm64.  

Support for x-arch is available on DockerHub and GitLab until quay.io supports multi-arch manifests.

### DockerHub

* `jitesoft/php`
    * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`
    * `7.2-fpm`
    * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `7.3`, `stable`, `latest`
    * `7.2-cli`, `7.2`

### GitLab

* `registry.gitlab.com/jitesoft/dockerfiles/php/fpm`
    * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`
    * `7.2-fpm`
* `registry.gitlab.com/jitesoft/dockerfiles/php/cli`
    * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `7.3`, `stable`, `latest`
    * `7.2-cli`, `7.2`

### Quay.io

* `quay.io/jitesoft/php`
    * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`
    * `7.2-fpm`
    * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `7.3`, `stable`, `latest`
    * `7.2-cli`, `7.2`


## Image labels

This image follows the [Jitesoft image label specification 1.0.0](https://gitlab.com/snippets/1866155).

## License

Read the PHP license [here](https://www.php.net/license/index.php).  
The files in this repository are released under the [MIT license](https://gitlab.com/jitesoft/dockerfiles/php/blob/master/LICENSE).

