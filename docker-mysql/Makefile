all: build

build: Dockerfile my.cnf
	docker build -t gitorious/mysql .

push:
	docker push gitorious/mysql:latest
