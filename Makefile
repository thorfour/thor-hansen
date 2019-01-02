.PHONY: hugo
hugo:
	docker build -t hugo --build-arg HUGO_VERSION=0.53 .
