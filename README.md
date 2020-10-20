VPN Deployer
===

## Deprecation Notice

This repo is only for deployment scripts. The application can now be found in [jmarhee/vpn_deployer_heroku](https://git-central.openfunction.co/jmarhee/vpn_deployer_heroku).

Overview
---

**Note: If you are not a user of DigitalOcean, but wish to deploy the server, I recommend using the [user-data script](https://raw.githubusercontent.com/jmarhee/dockvpn/master/provision.sh) with any Ubuntu or Debian machine on a provider, more details can be found [here](https://github.com/jmarhee/vpn_deployer#running-your-own-instance-of-the-deployer).**

Deploys a Docker-based VPN server one-click solution on DigitalOcean. The package this deploys is <a href="https://github.com/jmarhee/dockvpn">jmarhee/dockvpn</a>.

**Visit my Deployer instance: <a href="https://vpn-deploy.arcology.io/">https://vpn-deploy.arcology.io/<a/>**

**You can read more about this project <a href="https://medium.com/@jmarhee/automating-deploying-a-personal-vpn-server-on-digitalocean-f585aca396cf#.oo5tuvo9b">on Medium</a>.**

This will allow you to provide a one-click solution to DigitalOcean users for a VPN service, through your application. Running a private instance of this can be for your own use (it will work when run in development mode locally!), or to provide more availability for helping others run their own VPN servers and begin being more mindful about how they browse the Internet. 

Running your own instance of the deployer
---

*Note* This repo _only_ runs the deployer. **To run the VPN server itself, check out <a href="https://github.com/jmarhee/dockvpn">jmarhee/dockvpn</a>**. 

### Using Terraform

To deploy to DigitalOcean behind a Load Balancer:

```bash
cd deploy
```
Then populate `terraform.tfvars`, and apply:
```
terraform apply
```

### Manually build server container

Copy `environment.rb.example` to `environment.rb`, or using environmental variables with Docker below, populate with your DigitalOcean Application key and secret, and build:

```
docker build -t vpn_deployer-app .
```

and run:

```
docker run -d --restart always --name vpn_deployer -p 8080:4567 -e pushover_token=${pushover_token} -e pushover_user=${pushover_user} -e client_id="${client_id}" -e client_secret="${client_secret}" vpn_deployer
```

Once the image is available

Running standalone VPN
---

If you are planning to run the VPN service by itself, and don't particularly want to run an instance of the deployer itself (totally not necessary!), it will run on _any_ Docker host running a recent Debian (7+)/Ubuntu (14.04+) release, and you can jump ahead to running this script (if your provider supports cloud-init/provisioning scripts, or just run manually):

```bash
#!/bin/bash

function install_pkgs() {
    apt-get update && \
    apt-get install -y git-core curl
}

function install_compose() {
    curl -L "https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
}

function deploy_vpn() {
    git clone https://github.com/jmarhee/dockvpn.git && \
    cd dockvpn && \
    docker-compose up -d
}

install_pkgs && install_compose && deploy_vpn
```

Details on this project can be found in the <a href="https://github.com/jmarhee/dockvpn">jmarhee/dockvpn</a> project. 
