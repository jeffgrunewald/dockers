MAINTAINER?=jeffgrunewald
NAME?=openstackcli
VERSION?=2.3

default:
	@echo "Usage: make [target] <ENVVAR=value>"
	@echo "\nThese are the targets:\n"
	@echo "\tdefault:       prints this help"
	@echo "\tbuild:         tags the current builds with $(VERSION)"
	@echo "\tpush:          pushes the latest version"
	@echo "\nThese are the ENVVAR and their defaults:\n"
	@echo "\tMAINTAINER:  $(MAINTAINER)"
	@echo "\tNAME:          $(NAME)"
	@echo "\tVERSION:       $(VERSION)"
	@echo "\n*************************** NOTE *****************************"
	@echo "* this Makefile requires docker to be installed              *"
	@echo "* - docker: https://www.docker.com/                          *"
	@echo "*************************** NOTE *****************************\n"

build:
	docker build --force-rm=true --pull=true --tag=$(MAINTAINER)/$(NAME):$(VERSION) .

test: build
	bundle exec rake

push: test
	docker push $(MAINTAINER)/$(NAME):$(VERSION)
