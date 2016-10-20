#quick-nextcloud

For when you want a dockerized nextcloud instance... quickly!

##make nextcloud
* creates a docker template
* starts a docker reverse proxy if needed
* spins up a MariaDB docker instance
  * db files mounted locally in the db directory
* spins up a Nextcloud docker instance
  * app files mounted locally in app directory
  * config files mounted locally in config directory
  * data files mounted locally in data directory

##make nuke
* kills running nextcloud instance
* removes running nexcloud containers
* offers to sterlize the db, apps, config, data directories

to use: `make nextcloud` and follow simple prompts
