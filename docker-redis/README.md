# Gitorious Redis Docker image

A docker image including Redis 2.8, based on Ubuntu 14.04 LTS.

## Exported ports

* 6379 (redis-server)

## Exported volumes

* `/var/lib/redis` - `dump.rdb` is stored in it,
* `/var/log/redis` - daemon logs.

## Starting

    docker run gitorious/redis

If you want to persist redis database and logs:

    docker run -v /var/lib/gitorious/redis:/var/lib/redis -v /var/log/gitorious/redis:/var/log/redis gitorious/redis

## Maintainers

* Marcin Kulik
