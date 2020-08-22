provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = file(var.ssh_public_key_path)
}
