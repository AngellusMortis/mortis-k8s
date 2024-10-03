resource "cloudflare_record" "dns" {
    zone_id = var.zone_id
    name = "${var.second_subdomain}.${var.subdomain}"
    proxied = true
    content = "${var.tunnel_id}.cfargotunnel.com"
    type = "CNAME"
    tags = var.dns_tags
}

resource "cloudflare_zero_trust_access_application" "application" {
    account_id = var.account_id
    name = var.name
    domain = "${var.second_subdomain}.${var.subdomain}.${var.base_domain}"
    type = "self_hosted"
    session_duration = "24h"

    allow_authenticate_via_warp = false
    app_launcher_visible = false
    logo_url = var.icon
    auto_redirect_to_identity = true
    allowed_idps = var.idps
    http_only_cookie_attribute = true
    policies = var.policies
}
