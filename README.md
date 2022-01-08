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

The runtime images includes the following extra extensions: gd (jpg, webp, png), zip, imagick, gmp and redis.  
These might change during it's lifetime.

### DockerHub

* `jitesoft/php`
    * `8.1-fpm`, `fpm`, `latest-fpm`, `stable-fpm` 
    * `8.0-fpm`
    * `7.4-fpm`
    * `8.1`, `cli`, `8.1-cli`, `stable`, `stable-cli`, `latest`, `latest-cli`
    * `8.0`, `8.0-cli`
    * `7.4`, `7.4-cli`
* `jitesoft/php` (runtime)
  * `8.1-runtime-fpm`, `latest-runtime-fpm`, `stable-runtime-fpm`, `fpm-runtime`
  * `8.0-runtime-fpm`
  * `7.4-runtime-fpm`,
  * `8.1-runtime`, `8.1-runtime-cli`, `latest-runtime-cli` `stable-runtime-cli`, `stable-runtime`, `latest-runtime`
  * `8.0-runtime-cli`, `8.0-runtime`
  * `7.4-runtime-cli`, `7.4-runtime`
  
### GitLab

* `registry.gitlab.com/jitesoft/dockerfiles/php/fpm`
    * `8.1`, `latest`, `stable`
    * `8.0`
    * `7.4`
* `registry.gitlab.com/jitesoft/dockerfiles/php/cli`
  * `8.1`, `latest`, `stable`
  * `8.0`
    * `7.4`
* `registry.gitlab.com/jitesoft/dockerfiles/php/runtime/cli`
  * `8.1`, `latest`, `stable`
  * `8.0`
  * `7.4`
* `registry.gitlab.com/jitesoft/dockerfiles/php/runtime/fpm`
  * `8.1`, `latest`, `stable`
  * `8.0`
  * `7.4`
  
### GitHub

* `ghcr.io/jitesoft/php`
    * `8.1-fpm`, `latest-fpm`, `stable-fpm`, `fpm`
    * `8.0-fpm`
    * `7.4-fpm`
    * `8.1`, `cli`, `8.1-cli`, `latest-cli` `stable-cli`, `stable`, `latest`
    * `8.0-cli`, `8.0`
    * `7.4-cli`, `7.4`
* `ghcr.io/jitesoft/php` (runtime)
    * `8.1-runtime-fpm`, `latest-runtime-fpm`, `stable-runtime-fpm`, `fpm-runtime`
    * `8.0-runtime-fpm`
    * `7.4-runtime-fpm`
    * `8.1-runtime`, `8.1-runtime-cli`, `latest-runtime-cli` `stable-runtime-cli`, `stable-runtime`, `latest-runtime`
    * `8.0-runtime-cli`, `8.0-runtime`
    * `7.4-runtime-cli`, `7.4-runtime`

### Quay.io

* `quay.io/jitesoft/php`
    * `fpm`, `7.4-fpm`, `latest-fpm`, `stable-fpm`
    * `cli`, `latest-cli` `7.4-cli`, `stable-cli`, `7.4`, `stable`, `latest`

_Observe: Push to quay.io currently disabled and images might be old due to quay not fully supporting multi-arch images._

## Image labels

This image follows the [Jitesoft image label specification 1.0.0](https://gitlab.com/snippets/1866155).

## License

Read the PHP license [here](https://www.php.net/license/index.php).  
The files in this repository are released under the [MIT license](https://gitlab.com/jitesoft/dockerfiles/php/blob/master/LICENSE).

### Sponsors

Jitesoft images are built via GitLab CI on runners hosted by the following wonderful organisations:

<a href="https://fosshost.org/">
  <img src="https://raw.githubusercontent.com/jitesoft/misc/master/sponsors/fosshost.png" height="128" alt="Fosshost logo" />
</a>
<a href="https://www.aarch64.com/">
  <img src="https://raw.githubusercontent.com/jitesoft/misc/master/sponsors/aarch64.png" height="128" alt="Aarch64 logo" />
</a>

_The companies above are not affiliated with Jitesoft or any Jitesoft Projects directly._

---

Sponsoring is vital for the further development and maintaining of open source.  
Questions and sponsoring queries can be made by <a href="mailto:sponsor@jitesoft.com">email</a>.  
If you wish to sponsor our projects, reach out to the email above or visit any of the following sites:

[Open Collective](https://opencollective.com/jitesoft-open-source)  
[GitHub Sponsors](https://github.com/sponsors/jitesoft)  
[Patreon](https://www.patreon.com/jitesoft)

