locals {
    envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
}

terraform {
    required_providers {
        authentik = {
            source = "goauthentik/authentik"
            version = "~> 2024.8.0"
        }
        random = {
            source = "hashicorp/random"
            version = "~> 3.0"
        }
    }
}

provider "authentik" {
    url   = "https://auth.wl.mort.is"
    token = local.envs.AUTHENTIK_TOKEN
}

provider "random" {}
