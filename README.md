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
These might change during its lifetime.

### DockerHub

* `jitesoft/php`

Runtime images are tagged as `<version>-runtime-<type>`
  
### GitLab

* `registry.gitlab.com/jitesoft/dockerfiles/php/fpm`
* `registry.gitlab.com/jitesoft/dockerfiles/php/cli`
* `registry.gitlab.com/jitesoft/dockerfiles/php/runtime/cli`
* `registry.gitlab.com/jitesoft/dockerfiles/php/runtime/fpm`
  
### GitHub

* `ghcr.io/jitesoft/php`

Runtime images are tagged as `<version>-runtime-<type>`

### Quay.io

* `quay.io/jitesoft/php`

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

