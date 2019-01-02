.PHONY: hugo generate deploy

hugo:
	docker build -t hugo --build-arg HUGO_VERSION=0.53 .

generate:
	docker run -v ${PWD}/hugo:/hugo -w /hugo hugo -b https://thor-hansen.com

deploy:
	docker run -i -t -v ${PWD}:${PWD} -w ${PWD}/terraform hashicorp/terraform:light init
	docker run -i \
	   	-t \
	   	-v ~/.ssh:/root/.ssh \
		-v ${PWD}:${PWD} \
		-w ${PWD}/terraform \
	   	hashicorp/terraform:light apply
