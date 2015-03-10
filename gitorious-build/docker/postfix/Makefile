all: build

build: Dockerfile
	docker build -t gitorious/postfix .

push:
		docker push gitorious/postfix:latest
