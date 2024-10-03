## Media Apps
# Plex
resource "cloudflare_record" "wl_plex" {
    zone_id = cloudflare_zone.mortis.id
    name = "plex.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.media, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_plex" {
    account_id = local.account_id
    name = "Plex"
    domain = "plex.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://www.plex.tv/wp-content/themes/plex/assets/img/favicons/plex-180.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.bypass.id
    ]
}

# Overseer
resource "cloudflare_record" "wl_media" {
    zone_id = cloudflare_zone.mortis.id
    name = "media.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.media, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_media" {
    account_id = local.account_id
    name = "Overseer"
    domain = "media.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://overseerr.dev/favicon.ico"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.bypass.id
    ]
}
