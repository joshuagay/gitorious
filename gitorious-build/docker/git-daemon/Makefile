all: build

build: Dockerfile
	docker build -t gitorious/git-daemon .

push:
	docker push gitorious/git-daemon:latest
