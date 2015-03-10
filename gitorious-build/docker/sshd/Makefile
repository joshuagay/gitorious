all: build

build: Dockerfile
	docker build -t gitorious/sshd .

push:
	docker push gitorious/sshd:latest
