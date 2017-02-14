#!/bin/bash
docker build -t [your_docker_name]/sample-node .
docker push [your_docker_name]/sample-node

ssh [gcp_username]@[server_ip_address] << EOF
docker pull [your_docker_name]/sample-node:latest
# stop and remove a container
# '|| true' - allows us to ignore any error during the execution of command and proceed
docker stop web || true
docker rm web || true
# remove all images
docker rmi [your_docker_name]/sample-node:current || true
# change tag of a container from latest to current
docker tag [your_docker_name]/sample-node:latest [your_docker_name]/sample-node:current
# run a container with expost 80 port, which will restart in case of any error
docker run -d --restart always --name web -p 80:80 [your_docker_name]/sample-node:current
EOF
