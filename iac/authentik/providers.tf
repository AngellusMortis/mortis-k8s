locals {
    envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
}

terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2024.8.4"
    }
  }
}

provider "authentik" {
    url   = "https://auth.wl.mort.is"
    token = "${local.envs.AUTHENTIK_TOKEN}"
}
