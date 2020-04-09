[![License: AGPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-ngxp.svg)](https://travis-ci.org/Monogramm/docker-ngxp)
[![Docker Automated buid](https://img.shields.io/docker/build/monogramm/docker-ngxp.svg)](https://hub.docker.com/r/monogramm/docker-ngxp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-ngxp.svg)](https://hub.docker.com/r/monogramm/docker-ngxp/)

# NativeScript and Angular on Docker

Docker image for building cross platform applications using NativeScript, Angular and Android SDK.

## What is NGXP ?

A starter project to create web apps and NativeScript applications using NativeScript and AngularCLI with single shared code base.

> [More informations](https://github.com/Monogramm/ngxp-seed)

## Supported tags

<https://hub.docker.com/r/monogramm/docker-ngxp/>

-   `jdk`, `latest`
-   `alpine`

## How to run this image ?

This Docker image is based on the [official OpenJDK image](https://hub.docker.com/_/openjdk/).

This image is designed to be used in a build / test environment. There are two versions of the image you can choose from.

The `jdk` tag contains an OpenJDK environment with latest NativeScript, Angular. It is designed to be easy to use and gets you running pretty fast. This is also the default for the `latest` tag and version tags that are not further specified.

The second option is a `alpine` container. To use this image it must be combined with any webserver that can proxy the http requests to the FastCGI-port of the container.

## Adding Features

If the image does not include the packages you need, you can easily build your own image on top of it.
Start your derived image with the `FROM` statement and add whatever you like.

```yaml
FROM monogramm/docker-ngxp:alpine

RUN ...

```

You can also clone this repository and use the [update.sh](update.sh) shell script to generate a new Dockerfile based on your own needs.

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-ngxp) and write an issue.  

[uri_license]: http://www.gnu.org/licenses/agpl.html

[uri_license_image]: https://img.shields.io/badge/License-AGPL%20v3-blue.svg
