all: build

build: Dockerfile
	docker build -t gitorious/memcached .

push:
	docker push gitorious/memcached:latest
