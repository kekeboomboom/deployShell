#!/bin/bash

echo "Please run this script as root. Because it will install docker and docker-compose.
If you have installed docker and docker-compose, please ignore this message.
And i use docker-compose version is 3.8, so please make sure your docker engine version is 19.03.0+."

echo

# check user is root
whoami=$(whoami)
if [ "$whoami" != "root" ]; then
        echo "Please run as root."
        exit 1
fi

# check docker is installed

# verlt 24.0.5 19.03.0 && echo "yes" || echo "no" # no
# this function check $1 is less than $2
versionLessThan() {
        if [ "$1" = "$2" ]; then
                return 1
        else
                # sort -V: natural sort of (version) numbers within text
                [ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
        fi
}

if ! which docker >/dev/null 2>&1; then

        echo "docker is not installed. Start install docker."

        # install docker use offline package
        cd docker-install || exit

        sudo dpkg -i ./containerd.io_1.6.21-1_amd64.deb \
                ./docker-ce_24.0.2-1~ubuntu.20.04~focal_amd64.deb \
                ./docker-ce-cli_24.0.2-1~ubuntu.20.04~focal_amd64.deb \
                ./docker-buildx-plugin_0.10.5-1~ubuntu.20.04~focal_amd64.deb \
                ./docker-compose-plugin_2.18.1-1~ubuntu.20.04~focal_amd64.deb

        sudo service docker start

        cd ..
fi

echo "docker is installed."
# check docekr engine version
docker_version=$(docker version --format '{{.Server.Version}}')
echo "docker engine version is $docker_version"
# if docker_version less than 19.03.0, exit
if versionLessThan "$docker_version" "19.03.0"; then
        echo "docker engine version is less than 19.03.0, please upgrade docker engine."
        exit 1
fi

# laod images
docker load -i mysql.tar
docker load -i yourApplication.tar
docker load -i minio.tar

# start docker containers
docker compose up -d mysql yourApplication minio

# check minio is running
if pgrep -x "minio" >/dev/null; then
        echo "minio init..."
        # minio deploy: create access key and secret key, create bucket, webhook event
        docker exec -i minio bash < minioDeploy.sh
else
        echo "minio is not running. This will influence file upload and download."
fi