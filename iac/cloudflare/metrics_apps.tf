## Metrics Apps
# Alert Manager
resource "cloudflare_record" "wl_alerts" {
    zone_id = cloudflare_zone.mortis.id
    name = "alerts.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_alerts" {
    account_id = local.account_id
    name = "Alert Manager"
    domain = "alerts.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}

# Grafana
resource "cloudflare_record" "wl_monitor" {
    zone_id = cloudflare_zone.mortis.id
    name = "monitor.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_monitor" {
    account_id = local.account_id
    name = "Grafana"
    domain = "monitor.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://grafana.com/static/assets/img/fav32.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}

# K8s Dashboard
resource "cloudflare_record" "wl_k8s" {
    zone_id = cloudflare_zone.mortis.id
    name = "k8s.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_k8s" {
    account_id = local.account_id
    name = "Kubernetes Dashboard"
    domain = "k8s.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://kubernetes.io/icons/icon-128x128.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}

# Prometheus
resource "cloudflare_record" "wl_prometheus" {
    zone_id = cloudflare_zone.mortis.id
    name = "prometheus.wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.metrics, local.tags.k8s)
}

resource "cloudflare_zero_trust_access_application" "wl_prometheus" {
    account_id = local.account_id
    name = "Prometheus"
    domain = "prometheus.wl.${cloudflare_zone.mortis.zone}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
    auto_redirect_to_identity = true
    allowed_idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    http_only_cookie_attribute = true
    policies = [
        cloudflare_zero_trust_access_policy.allow_admin_users.id
    ]
}
