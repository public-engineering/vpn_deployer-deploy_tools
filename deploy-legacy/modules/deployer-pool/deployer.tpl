#!/bin/bash

apt update ; \
apt install git-core docker.io -y ; \
git clone https://github.com/jmarhee/vpn_deployer.git app ; \
cd app ; \
docker build -t vpn_deployer . && \
docker run -d --restart always --name vpn_deployer -p 8080:4567 -p 4443:4567 -e RELEASE="${release}" -e PUSHOVER_TOKEN=${pushover_token} -e PUSHOVER_USER=${pushover_user} -e client_id=${client_id} -e client_secret=${client_secret} vpn_deployer