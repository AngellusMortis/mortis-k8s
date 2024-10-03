resource "cloudflare_zero_trust_access_identity_provider" "authentik" {
    account_id = local.account_id
    name = "Authentik"
    type = "oidc"

    config {
        client_id = var.cloudflare_oidc_client_id
        client_secret = var.cloudflare_oidc_client_secret
        auth_url = "https://auth.wl.${cloudflare_zone.mortis.zone}/application/o/authorize/"
        token_url = "https://auth.wl.${cloudflare_zone.mortis.zone}/application/o/token/"
        certs_url = "https://auth.wl.${cloudflare_zone.mortis.zone}/application/o/cloudflare/jwks/"
        pkce_enabled = true
        email_claim_name = "email"
        claims = tolist(["groups"])
        scopes = tolist(["openid", "email", "profile"])
    }
}

resource "cloudflare_zero_trust_access_service_token" "uptime_robot" {
    account_id = local.account_id
    name = "UptimeRobot"
    duration = "forever"
}

resource "cloudflare_zero_trust_access_group" "all_users" {
    account_id = local.account_id
    name = "All Users"

    include {
        everyone = false
    }
}

resource "cloudflare_zero_trust_access_group" "admin_users" {
    account_id = local.account_id
    name = "Admin Users"

    include {
        everyone = false
    }
}

resource "cloudflare_zero_trust_access_group" "home_users" {
    account_id = local.account_id
    name = "Home Users"

    include {
        everyone = false
    }
}

resource "cloudflare_zero_trust_access_group" "media_users" {
    account_id = local.account_id
    name = "Media Users"

    include {
        everyone = false
    }
}

resource "cloudflare_zero_trust_access_group" "media_ingest_users" {
    account_id = local.account_id
    name = "Media Ingest Users"

    include {
        everyone = false
    }
}

resource "cloudflare_zero_trust_access_group" "ssh_users" {
    account_id = local.account_id
    name = "SSH Users"

    include {
        everyone = false
    }
}
