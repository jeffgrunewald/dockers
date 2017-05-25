MAINTAINER?=jeffgrunewald
NAME?=base-ubuntu
TAG?=$(shell date +%Y%m%d-%H%M)
SHA?=$(shell git rev-parse HEAD)

default:
	@echo "Usage: make [target] <ENVVAR=value>"
	@echo "\nThese are the targets:\n"
	@echo "\tdefault:       prints this help"
	@echo "\tbuild:         tags the current builds with $(TAG)"
	@echo "\tpush:          pushes the latest versions"
	@echo "\nThese are the ENVVAR and their defaults:\n"
	@echo "\tMAINTAINER:  $(MAINTAINER)"
	@echo "\tNAME:          $(NAME)"
	@echo "\n*************************** NOTE *****************************"
	@echo "* this Makefile requires docker to be installed              *"
	@echo "* - docker: https://www.docker.com/                          *"
	@echo "*************************** NOTE *****************************\n"

build:
	docker build --force-rm=true --pull=true --label git_sha=$(SHA) --tag=$(MAINTAINER)/$(NAME):$(TAG) .

test:
	bundle exec rake

push: test
	docker push $(MAINTAINER)/$(NAME):$(TAG)
