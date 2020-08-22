variable "digitalocean_token" {}

variable "droplet_size" {
  default = "1gb"
}
variable "region" {
  default = "nyc3"
}
variable "pool_size" {
  default = 2
}
variable "ssh_public_key_path" {
  default = "$HOME/.ssh/id_rsa.pub"
}

variable "host_record" {
  default = "@"
}

variable "digitalocean_domain" {
  description = "Cloudflare Domain"
  default     = "your_domain.com"
}

variable "client_id" {}
variable "client_secret" {}
variable "pushover_user" {}
variable "pushover_token" {}


