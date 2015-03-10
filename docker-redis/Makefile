all: build

build: Dockerfile
	docker build -t gitorious/redis .

push:
	docker push gitorious/redis:latest
