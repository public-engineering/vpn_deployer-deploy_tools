variable "droplet_size" {}
variable "ssh_key_fingerprints" {}
variable "region" {}
variable "pushover_token" {}
variable "pushover_user" {}
variable "client_id" {}
variable "client_secret" {}
variable "cloudflare_zone_id" {}
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

resource "digitalocean_loadbalancer" "public" {
  name   = "vpn-deployer"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8080
    target_protocol = "http"
  }

  healthcheck {
    port     = 8080
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.deployer.*.id
}

resource "cloudflare_record" "dial" {
  zone_id = var.cloudflare_zone_id
  name    = var.host_record
  value   = digitalocean_loadbalancer.public.ip
  type    = "A"
  ttl     = 1
  proxied = true
}
