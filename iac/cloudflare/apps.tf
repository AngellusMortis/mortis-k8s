locals {
    control_apps = {
        "authentik" = {
            name = "Authentik"
            icon = "https://goauthentik.io/img/icon.png"
            second_subdomain = "auth"
            policies = [cloudflare_zero_trust_access_policy.bypass.id]
        },
        "ssh-bastion" = {
            name = "SSH Bastion"
            second_subdomain = "ssl"
            policies = [cloudflare_zero_trust_access_policy.allow_ssh_users.id]
        },
        "fr" = {
            name = "Egress SSH"
            second_subdomain = "fr"
            tunnel_id = "ac085653-976a-425f-81c9-b40d1dd883f6"
            policies = [cloudflare_zero_trust_access_policy.allow_ssh_users.id]
        },
        "longhorn" = {
            name = "Longhorn"
            second_subdomain = "longhorn"
            icon = "https://longhorn.io/img/logos/longhorn-icon-color.png"
        },
        "crashplan" = {
            name = "CrashPlan"
            second_subdomain = "backup"
            icon = "https://www.crashplan.com/wp-content/uploads/CrashPlan-Favicon.png"
        },
        "unifi-network" = {
            name = "UniFi Network"
            second_subdomain = "network"
            icon = "https://content-cdn.svc.ui.com/static/favicon.ico"
        },
        "fluxcd" = {
            name = "FluxCD"
            second_subdomain = "cd"
            icon = "https://fluxcd.io/favicons/favicon-32x32.png"
        },
    }
    home_apps = {
        "birdnet" = {
            name = "BirdNET"
            second_subdomain = "birds"
            icon = "https://raw.githubusercontent.com/tphakala/birdnet-go/main/doc/BirdNET-Go-logo.webp"
        },
        "home-assistant" = {
            name = "Home Assistant"
            second_subdomain = "home"
            icon = "https://www.home-assistant.io/images/favicon-192x192.png"
        },
        "paperless" = {
            name = "Paperless"
            second_subdomain = "paperless"
            icon = "https://docs.paperless-ngx.com/assets/favicon.png"
        },
        "span" = {
            name = "SPAN"
            second_subdomain = "power"
            icon = "https://cdn.prod.website-files.com/628f26de26f0252b4094378b/628f31957d231cc922315f35_span-webclip.png"
        },
    }
    media_apps = {
        "plex" = {
            name = "Plex"
            second_subdomain = "plex"
            icon = "https://www.plex.tv/wp-content/themes/plex/assets/img/favicons/plex-180.png"
        },
        "files" = {
            name = "File Server"
            second_subdomain = "files"
        },
        "overseer" = {
            name = "Overseer"
            second_subdomain = "media"
            icon = "https://overseerr.dev/favicon.ico"
        },
    }
    metrics_apps = {
        "alerts" = {
            name = "Alert Manager"
            second_subdomain = "alerts"
            icon = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
        },
        "grafana" = {
            name = "Grafana"
            second_subdomain = "monitor"
            icon = "https://grafana.com/static/assets/img/fav32.png"
        },
        "k8s" = {
            name = "Kubernetes Dashboard"
            second_subdomain = "k8s"
            icon = "https://kubernetes.io/icons/icon-128x128.png"
        },
        "prometheus" = {
            name = "Prometheus"
            second_subdomain = "prometheus"
            icon = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
        },
    }
    dc_apps = {
        "syncthing" = {
            name = "SyncThing (Backup)"
            icon = "https://syncthing.net/img/favicons/apple-touch-icon-152x152.png"
            dns_tags = concat(local.tags.control, local.tags.media)
            second_subdomain = "sync"
        },
    }
}

module "control_apps" {
    source = "./access_app"
    for_each = local.control_apps

    name = each.value.name
    icon = try(each.value.icon, null)
    account_id = local.account_id
    zone_id = cloudflare_zone.mortis.id
    dns_tags = concat(local.tags.all, local.tags.wl, local.tags.k8s, local.tags.control)
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.wl.id)
    second_subdomain = each.value.second_subdomain
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.allow_admin_users.id])
}

module "home_apps" {
    source = "./access_app"
    for_each = local.home_apps

    name = each.value.name
    icon = try(each.value.icon, null)
    account_id = local.account_id
    zone_id = cloudflare_zone.mortis.id
    dns_tags = concat(local.tags.all, local.tags.wl, local.tags.k8s, local.tags.home)
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.wl.id)
    second_subdomain = each.value.second_subdomain
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.allow_home_users.id])
}

module "media_apps" {
    source = "./access_app"
    for_each = local.media_apps

    name = each.value.name
    icon = try(each.value.icon, null)
    account_id = local.account_id
    zone_id = cloudflare_zone.mortis.id
    dns_tags = concat(local.tags.all, local.tags.wl, local.tags.k8s, local.tags.media)
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.wl.id)
    second_subdomain = each.value.second_subdomain
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.bypass.id])
}

module "metrics_apps" {
    source = "./access_app"
    for_each = local.metrics_apps

    name = each.value.name
    icon = try(each.value.icon, null)
    account_id = local.account_id
    zone_id = cloudflare_zone.mortis.id
    dns_tags = concat(local.tags.all, local.tags.wl, local.tags.k8s, local.tags.metrics)
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.wl.id)
    second_subdomain = each.value.second_subdomain
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.allow_admin_users.id])
}

module "dc_apps" {
    source = "./access_app"
    for_each = local.dc_apps

    name = each.value.name
    icon = try(each.value.icon, null)
    account_id = local.account_id
    zone_id = cloudflare_zone.mortis.id
    dns_tags = concat(local.tags.all, local.tags.dc, each.value.dns_tags)
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.dc.id)
    second_subdomain = each.value.second_subdomain
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.allow_admin_users.id])
    subdomain = "dc"
}
