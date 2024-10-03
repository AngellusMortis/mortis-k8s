## Control Apps
# Authentik
resource "cloudflare_record" "wl_auth" {
    zone_id = cloudflare_zone.mortis.id
    name = "auth.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.control, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_auth" {
    account_id = local.account_id
    name = "Authentik"
    domain = "auth.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://goauthentik.io/img/icon.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.bypass.id
    ]
}

# SSH Bastion
resource "cloudflare_record" "wl_ssh" {
    zone_id = cloudflare_zone.mortis.id
    name = "ssh.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.control, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_ssh" {
    account_id = local.account_id
    name = "SSH Bastion"
    domain = "ssh.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_ssh_users.id
    ]
}

# FR SSH Bastion
resource "cloudflare_record" "fr_ssh" {
    zone_id = cloudflare_zone.mortis.id
    name = "fr"
    proxied = true
    content = "ac085653-976a-425f-81c9-b40d1dd883f6.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.fr, local.tags.control)
}

resource "cloudflare_zero_trust_access_application" "fr_ssh" {
    account_id = local.account_id
    name = "Egress SSH"
    domain = "fr.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_ssh_users.id
    ]
}

# Longhorn
resource "cloudflare_record" "wl_longhorn" {
    zone_id = cloudflare_zone.mortis.id
    name = "longhorn.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_longhorn" {
    account_id = local.account_id
    name = "Longhorn"
    domain = "longhorn.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://longhorn.io/img/logos/longhorn-icon-color.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}

# CrashPlan
resource "cloudflare_record" "wl_backup" {
    zone_id = cloudflare_zone.mortis.id
    name = "backup.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_backup" {
    account_id = local.account_id
    name = "CrashPlan"
    domain = "backup.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://www.crashplan.com/wp-content/uploads/CrashPlan-Favicon.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}

# UniFi Network
resource "cloudflare_record" "wl_network" {
    zone_id = cloudflare_zone.mortis.id
    name = "network.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_network" {
    account_id = local.account_id
    name = "UniFi Network"
    domain = "network.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://content-cdn.svc.ui.com/static/favicon.ico"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}

# FluxCD
resource "cloudflare_record" "wl_cd" {
    zone_id = cloudflare_zone.mortis.id
    name = "cd.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_cd" {
    account_id = local.account_id
    name = "FluxCD"
    domain = "cd.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://fluxcd.io/favicons/favicon-32x32.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}
