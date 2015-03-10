# Gitorious git-daemon Docker image

A docker image including git-daemon 1.9.1, based on Ubuntu 14.04 LTS.

## Exported ports

* 9418 (git-daemon)

## Exported volumes

None.

## Required volumes

* `/srv/gitorious/data/repositories` - `git-daemon` is configured to serve all
  repositories from this path.

## Starting

With repositories from other, data-only container named `data`:

    docker run -p 9418:9418 --volumes-from data gitorious/git-daemon

With repositories mounted directly from the host machine:

    docker run -p 9418:9418 -v /path/to/repositories:/srv/gitorious/data/repositories gitorious/git-daemon

## Maintainers

* Marcin Kulik
