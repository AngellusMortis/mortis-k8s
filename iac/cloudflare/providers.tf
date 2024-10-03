locals {
    envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
    account_id = "d1a777c19cccf42e7b8b45ffb654a978"
}

terraform {
    required_providers {
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "~> 4.0"
        }
    }
}

provider "cloudflare" {
    api_token = local.envs.CLOUDFLARE_API_TOKEN
}
