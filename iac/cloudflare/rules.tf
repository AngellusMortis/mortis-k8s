locals {
    redirects = tolist([
        {from="l.mort.is/media", to="https://gist.github.com/AngellusMortis/faa2d8d0967405628e9482e5d5af6690"}
    ])
}

resource "cloudflare_page_rule" "files" {
    zone_id = cloudflare_zone.mortis.id
    target = "files.wl.${cloudflare_zone.mortis.zone}/*"
    priority = 3
    status = "active"

    actions {
        cache_level = "cache_everything"
    }
}

resource "cloudflare_page_rule" "redirects" {
    count = length(local.redirects)

    zone_id = cloudflare_zone.mortis.id
    target = local.redirects[count.index].from
    priority = 2
    status = "active"

    actions {
        forwarding_url {
            url = local.redirects[count.index].to
            status_code = 301
        }
    }
}

resource "cloudflare_page_rule" "no_cache_plex" {
    zone_id = cloudflare_zone.mortis.id
    target = "plex.wl.${cloudflare_zone.mortis.zone}/*"
    priority = 1
    status = "active"

    actions {
        cache_level = "bypass"
        disable_zaraz = true
        disable_apps = true
        rocket_loader = "off"
    }
}

resource "cloudflare_ruleset" "block_foreign" {
    kind = "zone"
    name = "Block non-US"
    phase = "http_request_firewall_custom"
    zone_id = cloudflare_zone.mortis.id

    rules {
        action = "block"
        expression  = "(ip.geoip.country ne \"US\" and http.host ne \"files.wl.mort.is\")"
        description = "Non-US requests"
    }
}

# resource "cloudflare_ruleset" "managed_cf_ruleset" {
#     zone_id = cloudflare_zone.mortis.id
#     name = "Cloudflare Managed Ruleset"
#     kind = "zone"
#     phase = "http_request_firewall_managed"

#     rules {
#         action = "execute"
#         action_parameters {
#             id = "efb7b8c949ac4650a09736fc376e9aee"
#         }
#         expression = null
#         enabled = true
#     }
# }

# resource "cloudflare_ruleset" "managed_cf_owasp" {
#     zone_id = cloudflare_zone.mortis.id
#     name = "Cloudflare OWASP Core Ruleset"
#     kind = "zone"
#     phase = "http_request_firewall_managed"

#     rules {
#         action = "execute"
#         action_parameters {
#             id = "4814384a9e5d4991b9815dcfc25d2f1f"
#         }
#         expression = null
#         enabled = true
#     }
# }

# resource "cloudflare_ruleset" "managed_cf_credntials" {
#     zone_id = cloudflare_zone.mortis.id
#     name = "Cloudflare Leaked Credentials Check"
#     kind = "zone"
#     phase = "http_request_firewall_managed"

#     rules {
#         action = "execute"
#         action_parameters {
#             id = "c2e184081120413c86c3ab7e14069605"
#         }
#         expression = null
#         enabled = true
#     }
# }
