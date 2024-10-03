resource "cloudflare_record" "dc_syncthing" {
    zone_id = cloudflare_zone.mortis.id
    name = "sync.dc"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.dc.id}.cfargotunnel.com"
    type = "CNAME"
    tags = ["dc", "media"]
}

resource "cloudflare_zero_trust_access_policy" "allow_admin_users" {
    account_id = local.account_id
    name = "Allow Admin Users"
    decision = "allow"

    include {
        group = [cloudflare_zero_trust_access_group.admin_users.id]
    }

    require {
        email = [cloudflare_zero_trust_access_group.admin_users.id]
    }
}

resource "cloudflare_zero_trust_access_application" "dc_syncthing" {
    account_id = local.account_id
    name = "SyncThing (Backup)"
    domain = "sync.dc.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://syncthing.net/img/favicons/apple-touch-icon-152x152.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}
