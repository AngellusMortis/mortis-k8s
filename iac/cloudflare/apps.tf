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
        "ca" = {
            name = "Egress SSH"
            subdomain = "ca"
            tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.ca.id
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
        "nessus" = {
            name = "Nessus"
            second_subdomain = "nessus"
            icon = "https://www.tenable.com/themes/custom/tenable/img/favicons/favicon.ico"
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
        "solar" = {
            name = "Enphase Envoy"
            second_subdomain = "solar"
            icon = "https://enphase.com/apple-touch-icon.png"
        },
        "unifi-protect" = {
            name = "UniFi Protect"
            second_subdomain = "protect"
            icon = "https://content-cdn.svc.ui.com/static/favicon.ico"
        },
        "vacuum" = {
            name = "Valetudo"
            second_subdomain = "vacuum"
            icon = "https://valetudo.cloud/favicon.ico"
        },
        "syncthing" = {
            name = "SyncThing"
            icon = "https://syncthing.net/img/favicons/apple-touch-icon-152x152.png"
            dns_tags = concat(local.tags.home, local.tags.media)
            second_subdomain = "sync"
        },
        "stash" = {
            name = "Stash"
            icon = "https://docs.stashapp.cc/favicon.ico"
            dns_tags = concat(local.tags.home, local.tags.media)
            second_subdomain = "stash"
        },
        "maintainerr" = {
            name = "Maintainerr"
            icon = "https://maintainerr.info/favicon.ico"
            dns_tags = concat(local.tags.home, local.tags.media)
            second_subdomain = "cleanup"
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
    media_ingest_apps = {
        "bazarr" = {
            name = "Bazarr"
            second_subdomain = "subs"
            icon = "https://www.bazarr.media/assets/img/favicon.ico"
        },
        "deluge" = {
            name = "Deluge"
            second_subdomain = "download"
            icon = "https://deluge-torrent.org/images/deluge_logo.png"
        },
        "radarr" = {
            name = "Radarr"
            second_subdomain = "movies"
            icon = "https://radarr.video/img/favicon.ico"
        },
        "prowlarr" = {
            name = "Prowlarr"
            second_subdomain = "index"
            icon = "https://prowlarr.com/img/favicon.ico"
        },
        "sonarr" = {
            name = "Sonarr"
            second_subdomain = "television"
            icon = "https://sonarr.tv/img/favicon.ico"
        },
        "fileflows" = {
            name = "FileFlows"
            second_subdomain = "processing"
            icon = "https://fileflows.com/img/favicon.ico"
        },
        "autobrr" = {
            name = "autobrr"
            second_subdomain = "autodl"
            icon = "https://autobrr.com/img/favicon.ico"
        },
        "lidarr" = {
            name = "Lidarr"
            second_subdomain = "music"
            icon = "https://lidarr.audio/img/favicon.ico"
        },
        "whisparr" = {
            name = "Whisparr"
            second_subdomain = "stuff"
            icon = "https://whisparr.com/logo/256.png"
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
        "ssh-bastion" = {
            name = "SSH Backup"
            second_subdomain = "ssh"
            dns_tags = local.tags.control
            policies = [cloudflare_zero_trust_access_policy.allow_ssh_users.id]
        },
        "deluge" = {
            name = "Deluge (Backup)"
            icon = "https://deluge-torrent.org/images/deluge_logo.png"
            dns_tags = concat(local.tags.media_ingest)
            second_subdomain = "download"
            policies = [cloudflare_zero_trust_access_policy.allow_media_ingest_users.id]
        },
        "plex" = {
            name = "Plex (Backup)"
            icon = "https://www.plex.tv/wp-content/themes/plex/assets/img/favicons/plex-180.png"
            dns_tags = concat(local.tags.media)
            second_subdomain = "plex"
            policies = [cloudflare_zero_trust_access_policy.bypass.id]
        },
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
    subdomain = try(each.value.subdomain, "wl")
    second_subdomain = try(each.value.second_subdomain, null)
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
    dns_tags = concat(local.tags.all, local.tags.wl, local.tags.k8s, try(each.value.dns_tags, local.tags.home))
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.wl.id)
    subdomain = try(each.value.subdomain, "wl")
    second_subdomain = try(each.value.second_subdomain, null)
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
    subdomain = try(each.value.subdomain, "wl")
    second_subdomain = try(each.value.second_subdomain, null)
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.bypass.id])
}

module "media_ingest_apps" {
    source = "./access_app"
    for_each = local.media_ingest_apps

    name = each.value.name
    icon = try(each.value.icon, null)
    account_id = local.account_id
    zone_id = cloudflare_zone.mortis.id
    dns_tags = concat(local.tags.all, local.tags.wl, local.tags.k8s, local.tags.media_ingest)
    tunnel_id = try(each.value.tunnel_id, cloudflare_zero_trust_tunnel_cloudflared.wl.id)
    subdomain = try(each.value.subdomain, "wl")
    second_subdomain = try(each.value.second_subdomain, null)
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.allow_media_ingest_users.id])
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
    subdomain = try(each.value.subdomain, "wl")
    second_subdomain = try(each.value.second_subdomain, null)
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
    subdomain = try(each.value.subdomain, "dc")
    second_subdomain = try(each.value.second_subdomain, null)
    base_domain = cloudflare_zone.mortis.zone
    idps = [cloudflare_zero_trust_access_identity_provider.authentik.id]
    policies = try(each.value.policies, [cloudflare_zero_trust_access_policy.allow_admin_users.id])
}
