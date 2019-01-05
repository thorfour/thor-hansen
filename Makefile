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
