.PHONY: deploy teardown

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

docker:
	docker run -i -t -v ${PWD}:${PWD} -w ${PWD}/template hashicorp/terraform:light init
	docker run -i \
	   	-t \
		-v ${PWD}:${PWD} \
		-w ${PWD}/template \
	   	hashicorp/terraform:light apply
	docker build -t quay.io/thorfour/thor-hansen .

clean:
	docker run -i -t -v ${PWD}:${PWD} -w ${PWD}/template hashicorp/terraform:light destroy
