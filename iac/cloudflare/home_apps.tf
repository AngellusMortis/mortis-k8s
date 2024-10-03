# BirdNET
resource "cloudflare_record" "wl_birds" {
    zone_id = cloudflare_zone.mortis.id
    name = "birds.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.home, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_birds" {
    account_id = local.account_id
    name = "BirdNET"
    domain = "birds.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://raw.githubusercontent.com/tphakala/birdnet-go/main/doc/BirdNET-Go-logo.webp"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_home_users.id
    ]
}

# Home Assistant
resource "cloudflare_record" "wl_home" {
    zone_id = cloudflare_zone.mortis.id
    name = "home.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.home, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_home" {
    account_id = local.account_id
    name = "Home Assistant"
    domain = "home.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://www.home-assistant.io/images/favicon-192x192.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_home_users.id
    ]
}

# Paperless
resource "cloudflare_record" "wl_paperless" {
    zone_id = cloudflare_zone.mortis.id
    name = "paperless.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.home, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_paperless" {
    account_id = local.account_id
    name = "Paperless"
    domain = "paperless.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://docs.paperless-ngx.com/assets/favicon.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_home_users.id
    ]
}

# SPAN
resource "cloudflare_record" "wl_power" {
    zone_id = cloudflare_zone.mortis.id
    name = "power.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.home, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_power" {
    account_id = local.account_id
    name = "SPAN"
    domain = "power.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://cdn.prod.website-files.com/628f26de26f0252b4094378b/628f31957d231cc922315f35_span-webclip.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_home_users.id
    ]
}
