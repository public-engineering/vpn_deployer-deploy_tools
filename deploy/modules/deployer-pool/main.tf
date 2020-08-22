variable "droplet_size" {}
variable "ssh_key_fingerprints" {}
variable "region" {}
variable "pushover_token" {}
variable "pushover_user" {}
variable "client_id" {}
variable "client_secret" {}
variable "cloudflare_zone_id" {}
variable "host_record" {}

data "template_file" "deployer" {
  template = "${file("${path.module}/deployer.tpl")}"

  vars = {
    client_id      = var.client_id
    client_secret  = var.client_secret
    pushover_token = var.pushover_token
    pushover_user  = var.pushover_user
  }
}

resource "random_string" "hostname" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

resource "digitalocean_droplet" "deployer" {
  name               = "deployer-node-${random_string.hostname.result}"
  image              = "ubuntu-18-04-x64"
  size               = var.droplet_size
  region             = var.region
  backups            = "false"
  private_networking = "false"
  ssh_keys           = var.ssh_key_fingerprints
  user_data          = data.template_file.deployer.rendered
}

resource "cloudflare_record" "dial" {
  zone_id = var.cloudflare_zone_id
  name    = var.host_record
  value   = digitalocean_droplet.deployer.ipv4_address
  type    = "A"
  ttl     = 1
  proxied = true
}
