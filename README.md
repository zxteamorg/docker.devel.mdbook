[![Build Status](https://github.com/zxteamorg/docker.mdbook/actions/workflows/build.yml/badge.svg)](https://github.com/zxteamorg/docker.mdbook/actions/workflows/build.yml)
[![Docker Image Version](https://img.shields.io/docker/v/zxteamorg/mdbook?sort=date&label=Version)](https://hub.docker.com/r/zxteamorg/mdbook/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/zxteamorg/mdbook?label=Image%20Size)](https://hub.docker.com/r/zxteamorg/mdbook/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/zxteamorg/mdbook?label=Image%20Pulls)](https://hub.docker.com/r/zxteamorg/mdbook)
[![Docker Stars](https://img.shields.io/docker/stars/zxteamorg/mdbook?label=Image%20Stars)](https://hub.docker.com/r/zxteamorg/mdbook)

# mdBook

[mdBook](https://rust-lang.github.io/mdBook/) is a command line tool to create books with Markdown.
It is ideal for creating product or API documentation, tutorials, course materials or anything that requires a clean, easily navigable and customizable presentation.

* Lightweight Markdown syntax helps you focus more on your content
* Integrated search support
* Color syntax highlighting for code blocks for many different languages
* Theme files allow customizing the formatting of the output
* Preprocessors can provide extensions for custom syntax and modifying content
* Backends can render the output to multiple formats
* Written in Rust for speed, safety, and simplicity

# Image reason

The image embedding fixed version of `mdBook` to prevent breaking changes in `mdBook` and it's dependencies.


# Spec

## Expose ports

* `tcp/8000` - `mdBook` development server listening endpoint


## Volumes

* `/data` - Sources root (bind/mount here your work directory)


# Inside

* [mdBook](https://rust-lang.github.io/mdBook/) v0.4.18
* [git](https://git-scm.com/) v2.36.2
* [libgcc](https://pkgs.alpinelinux.org/package/edge/main/x86_64/libgcc)


# Launch
1. Start development server in documentation root directory (where `mdbook.yml` located)
	```bash
	docker run --interactive --tty --rm --volume ${PWD}:/data --publish 8000:8000 zxteamorg/mdbook
	```
1. Open browser http://127.0.0.1:8000/
1. Edit content and look for hot-reloaded changes in the browser


# Support

* Maintained by: [ZXTeam](https://zxteam.org)
* Where to get help: [Telegram Channel](https://t.me/zxteamorg)


# Development

## Build
```shell
docker build --tag zxteamorg/mdbook --file Dockerfile .
```

## Build and launch
```shell
docker build --tag zxteamorg/mdbook --file Dockerfile . && docker run --interactive --tty --rm --volume ${PWD}:/data --publish 8000:8000 zxteamorg/mdbook
```