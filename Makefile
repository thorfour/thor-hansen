.PHONY: hugo

hugo:
	docker build -t hugo --build-arg HUGO_VERSION=0.53 .

generate:
	docker run -v ${PWD}/hugo:/hugo -w /hugo hugo
