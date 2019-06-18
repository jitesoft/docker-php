# PHP - Alpine

This image contains php built from source on the alpine linux distro.  
It's basically intended to be used by the `jitesoft` company and makes it possible to modify the source in an easier way for us.  

As you might notice when checking the file, it does use a whole lot of code from the official [PHP](https://github.com/docker-library/php/) image
on docker hub. This will change over time, for now, a lot of the code is borrowed to have a working image, while stuff will change a bit in the
future.

For now, the same commands as the official docker php image can be used for extensions (`docker-php-ext-enable`), these have also been added to
a shell script allowing for usage in the following format: `php-ext <command>` and are at the moment seen as deprecated (while no error will be produced still).

# Tags:

* FPM tags
  * `fpm`, `7.3-fpm`, `latest-fpm`, `stable-fpm`, `current-fpm`
  * `7.2-fpm`
  * `7.1-fpm`
* Cli tags
  * `cli`, `latest-cli` `7.3-cli`, `stable-cli`, `current-cli`, `7.3`, `current`, `stable`, `latest`
  * `7.2-cli`, `7.2`
  * `7.1-cli`, `7.1`

The CLI tags are the default if not using `fpm` specific and only contains PHP as cli, that is, not modified for any other usage than direct cli access.  

## Labels

## License
