MAINTAINER?=jeffgrunewald
TAG?=$(shell date +%Y%m%d-%H%M)
SHA?=$(shell git rev-parse HEAD)

.PHONY: default
default:
	@echo "Usage: make [target] <ENVVAR=value>"
	@echo "\nThese are the targets:\n"
	@echo "\tdefault:       prints this help"
	@echo "\tbuild:         tags the current builds with $(TAG)"
	@echo "\ttest:          runs any spec tests against the image"
	@echo "\tpush:          pushes the latest versions"
	@echo "\nThese are the ENVVAR and their defaults:\n"
	@echo "\tMAINTAINER:    $(MAINTAINER)"
	@echo "\tNAME:          $(NAME)"
	@echo "\n*************************** NOTE *****************************"
	@echo "* this Makefile requires docker to be installed              *"
	@echo "* - docker: https://www.docker.com/                          *"
	@echo "*************************** NOTE *****************************\n"

.PHONY: build
build:
	docker build --force-rm=true --pull=true --label git_sha=$(SHA) --tag=$(MAINTAINER)/$(NAME):$(TAG) .

.PHONY: test
test:
	bundle exec rake

.PHONY: push
push: test
	docker push $(MAINTAINER)/$(NAME):$(TAG)
