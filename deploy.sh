#!/bin/bash
docker build -t [your_docker_name]/sample-node .
docker push [your_docker_name]/sample-node

ssh [gcp_username]@[server_ip_address] << EOF
docker pull [your_docker_name]/sample-node:latest
docker stop web || true
docker rm web || true
docker rmi [your_docker_name]/sample-node:current || true
docker tag [your_docker_name]/sample-node:latest [your_docker_name]/sample-node:current
docker run -d --restart always --name web -p 3000:3000 [your_docker_name]/sample-node:current
EOF
