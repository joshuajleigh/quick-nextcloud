DKR := $(shell which docker 2> /dev/null)
DKRCMP := $(shell which docker-compose 2> /dev/null)

default: help

help:
	@echo "make help:"
	@echo
	@echo "        * nextcloud:   creates nextcloud instance"
	@echo
	@echo "        * nuke:   kills and cleans nexcloud instances"

_is_docker_installed:
ifndef DKR
        $(error docker not installed, see instructions https://docs.docker.com/engine/installation/)
endif

_is_compose_installed: _is_docker_installed
ifndef DKRCMP
	$(error docker-compose not installed, see https://docs.docker.com/compose/install/)
endif

template: _is_compose_installed
	@bash templater.sh
	@echo "created template"

nextcloud: template
	@docker-compose up -d
	@echo "spun up nextcloud and db"

kill:
	-@docker kill nextcloud_nextcloud_1 2> /dev/null
	-@docker kill nextcloud_db_nextcloud_1 2> /dev/null
	@echo "stopping the images"
	@sleep 1

remove: kill
	-@docker rm nextcloud_nextcloud_db_1 2> /dev/null
	-@docker rm nextcloud_nextcloud_db_1 2> /dev/null

nuke: remove
	@bash nuke.sh
