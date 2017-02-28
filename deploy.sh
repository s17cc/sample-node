#!/bin/bash
docker build -t kostyaurysov/sample-node .
docker push kostyaurysov/sample-node

ssh -i deploy deploy@35.187.30.81 << EOF
docker pull kostyaurysov/sample-node:latest
# stop and remove a container
# '|| true' - allows us to ignore any error during the execution of command and proceed
docker stop web || true
docker rm web || true
# remove all images
docker rmi kostyaurysov/sample-node:current || true
# change tag of a container from latest to current
docker tag kostyaurysov/sample-node:latest kostyaurysov/sample-node:current
# run a container with expost 80 port, which will restart in case of any error
docker run -d --restart always --name web -p 80:80 kostyaurysov/sample-node:current
EOF
