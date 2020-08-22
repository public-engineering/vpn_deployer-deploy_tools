variable "droplet_size" {}
variable "ssh_key_fingerprints" {}
variable "region" {}
variable "pushover_token" {}
variable "pushover_user" {}
variable "client_id" {}
variable "client_secret" {}
variable "digitalocean_domain" {}
variable "host_record" {}
variable "pool_size" {}

data "template_file" "deployer" {
  template = "${file("${path.module}/deployer.tpl")}"

  vars = {
    client_id      = var.client_id
    client_secret  = var.client_secret
    pushover_token = var.pushover_token
    pushover_user  = var.pushover_user
  }
}

resource "digitalocean_droplet" "deployer" {
  name               = format("deployer-node-%02d", count.index)
  count              = var.pool_size
  image              = "ubuntu-18-04-x64"
  size               = var.droplet_size
  region             = var.region
  backups            = "false"
  private_networking = "false"
  ssh_keys           = var.ssh_key_fingerprints
  user_data          = data.template_file.deployer.rendered
}

resource "digitalocean_certificate" "cert" {
  name    = "vpn-deployer"
  type    = "lets_encrypt"
  domains = ["${var.host_record}.${var.digitalocean_domain}"]
}

resource "digitalocean_loadbalancer" "public" {
  name   = "${var.host_record}.${var.digitalocean_domain}"
  region = var.region

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 8080
    target_protocol = "http"

    certificate_id = digitalocean_certificate.cert.id
  }

  healthcheck {
    port     = 8080
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.deployer.*.id
}

resource "digitalocean_domain" "default" {
  name       = "${var.host_record}.${var.digitalocean_domain}"
  ip_address = digitalocean_loadbalancer.public.ip
}
