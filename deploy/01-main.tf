module "vpn-deployers" {
  source = "./modules/deployer-pool"

  pushover_token       = var.pushover_token
  pushover_user        = var.pushover_user
  droplet_size         = var.droplet_size
  ssh_key_fingerprints = [digitalocean_ssh_key.default.fingerprint]
  region               = var.region
  count                = var.pool_size
  host_record          = var.host_record
  digitalocean_domain  = var.digitalocean_domain
  client_id            = var.client_id
  client_secret        = var.client_secret
}
