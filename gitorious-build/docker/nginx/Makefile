all: build

build: Dockerfile *.conf
	docker build -t gitorious/nginx .

push:
	docker push gitorious/nginx:latest
