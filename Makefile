.PHONY: hugo generate deploy clean

BASE_URL="https://thor-hansen.com"

hugo:
	docker build -t hugo --build-arg HUGO_VERSION=0.53 .

generate:
	mkdir ${PWD}/generated
	docker run -u $$(id -u) -v ${PWD}/generated:/generated -w /generated hugo new site hugo
	docker run -it --rm -u $$(id -u) -v ${PWD}/generated:/generated -w /generated/ alpine/git init
	docker run -it --rm -u $$(id -u) -v ${PWD}/generated:/generated -w /generated/hugo/themes alpine/git submodule add https://github.com/shenoybr/hugo-goa
	docker run -u $$(id -u) -v ${PWD}/hugo:/hugo -w /generated/hugo hugo -b $(BASE_URL)

deploy:
	docker run -i -t -v ${PWD}:${PWD} -w ${PWD}/terraform hashicorp/terraform:light init
	docker run -i \
	   	-t \
	   	-v ~/.ssh:/root/.ssh \
		-v ${PWD}:${PWD} \
		-w ${PWD}/terraform \
	   	hashicorp/terraform:light apply

teardown:
	docker run -i \
	   	-t \
	   	-v ~/.ssh:/root/.ssh \
		-v ${PWD}:${PWD} \
		-w ${PWD}/terraform \
	   	hashicorp/terraform:light destroy

clean:
	rm -rf ${PWD}/generated
