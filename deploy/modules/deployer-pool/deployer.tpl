#!/bin/bash

apt update ; \
apt install git-core docker.io -y ; \
git clone https://github.com/jmarhee/vpn_deployer.git app ; \
cd app ; \
docker build -t vpn_deployer . && \
docker run -d --restart always --name vpn_deployer -p 80:4567 -p 443:4567 -e pushover_token=${pushover_token} -e pushover_user=${pushover_user} -e client_id="${client_id}" -e client_secret="${client_secret}" vpn_deployer