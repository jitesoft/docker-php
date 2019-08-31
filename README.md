# PHP - Alpine

[![Docker Pulls](https://img.shields.io/docker/pulls/jitesoft/php.svg)](https://cloud.docker.com/u/jitesoft/repository/docker/jitesoft/php)
[![Back project](https://img.shields.io/badge/Open%20Collective-Tip%20the%20devs!-blue.svg)](https://opencollective.com/jitesoft-open-source)

This image contains php built from source on the alpine linux distro.  
It's basically intended to be used by the `jitesoft` company and makes it possible to modify the source in an easier way for us.  

As you might notice when checking the file, it does use a whole lot of code from the official [PHP](https://github.com/docker-library/php/) image
on docker hub. This will change over time, for now, a lot of the code is borrowed to have a working image, while stuff will change a bit in the
future.

For now, the same commands as the official docker php image can be used for extensions (`docker-php-ext-enable`), these have also been added to
a shell script allowing for usage in the following format: `php-ext <command>` and are at the moment seen as deprecated (while no error will be produced still).

## Tags:

### DockerHub

* FPM
  * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`
  * `7.2-fpm`
* CLI
  * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `7.3`, `stable`, `latest`
  * `7.2-cli`, `7.2`

The CLI tags are the default if not using `fpm` specific and only contains PHP as cli, that is, not modified for any other usage than direct cli access.  

### GitLab

The images are reachable through the gitlab container registry at gitlab.com, they use the following path and tags:

* `registry.gitlab.com/jitesoft/dockerfiles/php/fpm`
  * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`
  * `7.2-fpm`
* `registry.gitlab.com/jitesoft/dockerfiles/php/cli`
  * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `7.3`, `stable`, `latest`
  * `7.2-cli`, `7.2`

### Quay.io

* `quay.io/jitesoft/php`
    * FPM
      * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`
      * `7.2-fpm`
    * CLI
      * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `7.3`, `stable`, `latest`
      * `7.2-cli`, `7.2`


## Image labels

This image follows the [Jitesoft image label specification 1.0.0](https://gitlab.com/snippets/1866155).

## License

Read the PHP license [here](https://www.php.net/license/index.php).  
The files in this repository are released under the MIT license.

```text
MIT License

Copyright (c) 2019 Jitesoft

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
