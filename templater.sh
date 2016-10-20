#!/usr/bin/env bash


function PROXY {
RANDOM=$(shuf -i 1024-49151 -n 1)
DOMAINNAME=""
echo "what is the domain name? ex nextcloud.yourdomain.com"
read -e DOMAINNAME
cat << ENDOFFILE > docker-compose.yml
nextcloud:
  image: wonderfall/nextcloud
  links:
    - nextcloud_db:nextcloud_db
  environment:
    - UID=1000
    - GID=1000
    - VIRTUAL_HOST=$DOMAINNAME
  volumes:
    - ./data:/nextcloud/data
    - ./config:/nextcloud/config
    - ./apps:/nextcloud/apps
  ports:
    - $RANDOM:80

nextcloud_db:
  image: mariadb:10
  volumes:
    - ./db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=docker
    - MYSQL_DATABASE=nextcloud_db
    - MYSQL_USER=nextcloud
    - MYSQL_PASSWORD=docker

ENDOFFILE

docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy 2>/dev/null || true

}

function STANDALONE {

cat << ENDOFFILE > docker-compose.yml
nextcloud:
  image: wonderfall/nextcloud
  links:
    - nextcloud_db:nextcloud_db
  environment:
    - UID=1000
    - GID=1000
  volumes:
    - ./data:/nextcloud/data
    - ./config:/nextcloud/config
    - ./apps:/nextcloud/apps
  ports:
    - 80:80

nextcloud_db:
  image: mariadb:10
  volumes:
    - ./db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=docker
    - MYSQL_DATABASE=nextcloud_db
    - MYSQL_USER=nextcloud
    - MYSQL_PASSWORD=docker

ENDOFFILE
}

function CHOOSE {
echo "Do you want your nextclound to be.." 
echo " 1) a subdomain behind a nginx proxy, ex. nextcloud.yourdomain.com"
echo " 2) a stand alone nextcloud on port 80, ex yourdomain.com"
echo "q or Q to quit"
read -e INPUT
case $INPUT in
	1)	PROXY
		;;
	2)	STANDALONE
		;;
	[qQ])	echo "quitting per request"
		;;
	*)	echo "choose 1, 2, or quit (q)"
		CHOOSE
		;;
esac
}

CHOOSE
