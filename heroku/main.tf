provider "heroku" {
  version = "~> 2.0"
}

resource "heroku_app" "vpn_deployer" {
  name   = "${var.heroku_app_name}"
  region = "us"
}

resource "heroku_build" "vpn_deployer_build" {
  app        = "${heroku_app.vpn_deployer.name}"
  buildpacks = ["https://github.com/heroku/heroku-buildpack-ruby.git"]

  source = {
    url     = var.release_archive
    version = var.release
  }
}

resource "heroku_config" "common" {
  vars = {
    LOG_LEVEL = "info"
  }

  sensitive_vars = {
    client_id       = var.client_id
    client_secret   = var.client_secret
    pushover_token  = var.pushover_user
    pushover_secret = var.pushover_token
    release         = var.release
  }
}

resource "heroku_app_config_association" "vpn_deployer_config" {
  app_id = "${heroku_app.vpn_deployer.id}"

  vars           = "${heroku_config.common.vars}"
  sensitive_vars = "${heroku_config.common.sensitive_vars}"
}


resource "heroku_formation" "vpn_deployer_formation" {
  app        = "${heroku_app.vpn_deployer.name}"
  type       = "web"
  quantity   = 1
  size       = "Standard-1x"
  depends_on = ["heroku_build.vpn_deployer_build"]
}

resource "heroku_domain" "default" {
  app      = "${heroku_app.vpn_deployer.name}"
  hostname = var.app_domain
}

output "heroku_app_url" {
  value = "https://${heroku_app.vpn_deployer.name}.herokuapp.com"
}

output "app_domain_url" {
  value = "https://${var.app_domain}"
}
