all: build

build: Dockerfile
	docker build -t gitorious/app .

push:
	docker push gitorious/app:latest
