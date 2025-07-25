locals {
    control_apps = {
        "longhorn" = {
            name = "Longhorn"
            subdomain = "longhorn"
            description = "Kubernetes Storage Backend UI"
            icon = "https://longhorn.io/img/logos/longhorn-icon-color.png"
        },
        "crashplan" = {
            name = "CrashPlan"
            subdomain = "backup"
            description = "Backup service"
            icon = "https://www.crashplan.com/wp-content/uploads/CrashPlan-Favicon.png"
        },
        "unifi-network" = {
            name = "UniFi Network"
            subdomain = "network"
            description = "UniFi Network Controller"
            icon = "https://content-cdn.svc.ui.com/static/favicon.ico"
        },
        "fluxcd" = {
            name = "FluxCD"
            subdomain = "cd"
            description = "k8s automation service"
            icon = "https://fluxcd.io/favicons/favicon-32x32.png"
        },
        "nessus" = {
            name = "Nessus"
            subdomain = "nessus"
            description = "Infrastructure Scanner"
            icon = "https://www.tenable.com/themes/custom/tenable/img/favicons/favicon.ico"
        },
    }
    home_apps = {
        "birdnet" = {
            name = "BirdNET"
            subdomain = "birds"
            description = "Bird Analyzer"
            icon = "https://raw.githubusercontent.com/tphakala/birdnet-go/main/doc/BirdNET-Go-logo.webp"
        },
        "home-assistant" = {
            name = "Home Assistant"
            subdomain = "home"
            description = "Home Automation Service"
            icon = "https://www.home-assistant.io/images/favicon-192x192.png"
        },
        "paperless" = {
            name = "Paperless"
            subdomain = "paperless"
            description = "Digital Document Storage"
            icon = "https://docs.paperless-ngx.com/assets/favicon.png"
        },
        "span" = {
            name = "SPAN"
            subdomain = "power"
            description = "Electrical Panel"
            icon = "https://cdn.prod.website-files.com/628f26de26f0252b4094378b/628f31957d231cc922315f35_span-webclip.png"
        },
        "unifi-protect" = {
            name = "UniFi Protect"
            subdomain = "protect"
            description = "UniFi Protect Controller"
            icon = "https://content-cdn.svc.ui.com/static/favicon.ico"
        },
        "enphase-envoy" = {
            name = "Enphase Envoy"
            subdomain = "solar"
            description = "Solar Panels"
            icon = "https://enphase.com/apple-touch-icon.png"
            create_provider = true
            path = "/"
        },
        "valetudo-ground-floor" = {
            name = "Valetudo (Ground Floor)"
            subdomain = "vacuum"
            description = "Vacuum Control Interface for Ground Floor"
            icon = "https://valetudo.cloud/favicon.ico"
        },
        "valtuedo-downstairs" = {
            name = "Valetudo (Downstairs)"
            subdomain = "vacuum"
            description = "Vacuum Control Interface for Downstairs"
            icon = "https://valetudo.cloud/favicon.ico"
            create_provider = false
            path = "/downstairs/"
        },
        "syncthing" = {
            name = "SyncThing"
            group = "Media"
            subdomain = "sync"
            description = "File Sync Application"
            icon = "https://syncthing.net/img/favicons/apple-touch-icon-152x152.png"
        },
        "stash" = {
            name = "Stash"
            group = "Media"
            subdomain = "stash"
            description = "Porn Media Player"
            icon = "https://docs.stashapp.cc/favicon.ico"
        },
        "maintainerr" = {
            name = "Maintainerr"
            group = "Media"
            subdomain = "cleanup"
            description = "Media Cleanup Manager"
            icon = "https://maintainerr.info/favicon.ico"
        },
    }
    media_apps = {
        "plex" = {
            name = "Plex"
            subdomain = "plex"
            description = "Media Streaming Server"
            icon = "https://www.plex.tv/wp-content/themes/plex/assets/img/favicons/plex-180.png"
            create_provider = false
        },
        "overseer" = {
            name = "Overseer"
            subdomain = "media"
            description = "Media Requester"
            icon = "https://overseerr.dev/favicon.ico"
            create_provider = false
        },
    }
    media_ingest_apps = {
        "bazarr" = {
            name = "Bazarr"
            subdomain = "subs"
            description = "Subtitle Downloader"
            icon = "https://www.bazarr.media/assets/img/favicon.ico"
        },
        "deluge" = {
            name = "Deluge"
            subdomain = "download"
            description = "Download Service"
            icon = "https://deluge-torrent.org/images/deluge_logo.png"
        },
        "radarr" = {
            name = "Radarr"
            subdomain = "movies"
            description = "Movie Downloader"
            icon = "https://radarr.video/img/favicon.ico"
        },
        "prowlarr" = {
            name = "Prowlarr"
            subdomain = "index"
            description = "Download Indexer"
            icon = "https://prowlarr.com/img/favicon.ico"
        },
        "sonarr" = {
            name = "Sonarr"
            subdomain = "television"
            description = "Television Downloader"
            icon = "https://sonarr.tv/img/favicon.ico"
        },
        "fileflows" = {
            name = "FileFlows"
            subdomain = "processing"
            description = "File Processing"
            icon = "https://fileflows.com/img/favicon.ico"
        },
        "autobrr" = {
            name = "autobrr"
            subdomain = "autodl"
            description = "Auto-snatcher for Torrents"
            icon = "https://autobrr.com/img/favicon.ico"
        },
        "lidarr" = {
            name = "Lidarr"
            subdomain = "music"
            description = "Music Downloader"
            icon = "https://lidarr.audio/img/favicon.ico"
        },
        "whisparr" = {
            name = "Whisparr"
            subdomain = "stuff"
            description = "Porn Downloader"
            icon = "https://whisparr.com/logo/256.png"
        },
    }
    metrics_apps = {
        "alert-manager" = {
            name = "Alert Manager"
            subdomain = "alerts"
            description = "Alert Manager"
            icon = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
        },
        "prometheus" = {
            name = "Prometheus"
            subdomain = "prometheus"
            description = "Metric Scraper"
            icon = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
        },
    }
    dc_apps = {
        "download-backup" = {
            name = "Download (Backup)"
            subdomain = "download"
            group = "Media"
            description = "Download Service"
            icon = "https://deluge-torrent.org/images/deluge_logo.png"
            user_group = authentik_group.media_ingest.id
        },
        "plex-backup" = {
            name = "Plex (Backup)"
            subdomain = "plex"
            group = "Media"
            description = "Media Streaming Server"
            icon = "https://www.plex.tv/wp-content/themes/plex/assets/img/favicons/plex-180.png"
            create_provider = false
            user_group = authentik_group.media_users.id
        },
        "syncthing-backup" = {
            name = "SyncThing (Backup)"
            subdomain = "sync"
            group = "Media"
            description = "File Sync Application"
            icon = "https://syncthing.net/img/favicons/apple-touch-icon-152x152.png"
        },
    }
}

module "control_apps" {
    source = "./proxy_app"
    for_each = local.control_apps

    name = each.value.name
    slug = each.key
    group = try(each.value.group, "Control")
    icon = each.value.icon
    subdomain = each.value.subdomain
    description = each.value.description
    user_group = authentik_group.admin_users.id
    create_provider = try(each.value.create_provider, true)
    path = try(each.value.path, "/")
}


module "home_apps" {
    source = "./proxy_app"
    for_each = local.home_apps

    name = each.value.name
    slug = each.key
    group = try(each.value.group, "Home")
    icon = each.value.icon
    subdomain = each.value.subdomain
    description = each.value.description
    user_group = authentik_group.home_users.id
    create_provider = try(each.value.create_provider, true)
    path = try(each.value.path, "/")
}

module "media_apps" {
    source = "./proxy_app"
    for_each = local.media_apps

    name = each.value.name
    slug = each.key
    group = try(each.value.group, "Media")
    icon = each.value.icon
    subdomain = each.value.subdomain
    description = each.value.description
    user_group = authentik_group.media_users.id
    create_provider = try(each.value.create_provider, true)
    path = try(each.value.path, "/")
}

module "media_ingest_apps" {
    source = "./proxy_app"
    for_each = local.media_ingest_apps

    name = each.value.name
    slug = each.key
    group = try(each.value.group, "Media")
    icon = each.value.icon
    subdomain = each.value.subdomain
    description = each.value.description
    user_group = authentik_group.media_ingest.id
    create_provider = try(each.value.create_provider, true)
    path = try(each.value.path, "/")
}

module "metrics_apps" {
    source = "./proxy_app"
    for_each = local.metrics_apps

    name = each.value.name
    slug = each.key
    group = try(each.value.group, "Metrics")
    icon = each.value.icon
    subdomain = each.value.subdomain
    description = each.value.description
    user_group = authentik_group.admin_users.id
    create_provider = try(each.value.create_provider, true)
    path = try(each.value.path, "/")
}

module "dc_apps" {
    source = "./proxy_app"
    for_each = local.dc_apps

    name = each.value.name
    slug = each.key
    group = try(each.value.group, "Control")
    icon = each.value.icon
    subdomain = each.value.subdomain
    description = each.value.description
    user_group = try(each.value.user_group, authentik_group.admin_users.id)
    base_domain = "dc.mort.is"
    create_provider = try(each.value.create_provider, true)
    path = try(each.value.path, "/")
}

# Cloudflare OIDC
resource "authentik_provider_oauth2" "cloudflare" {
    name = "Cloudflare OIDC"
    client_id = "pMPFCSCQKjZLxMyGY1pucPM8YuyNDAQdfP3EmsOO"
    authentication_flow = data.authentik_flow.external_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    client_type = "confidential"
    redirect_uris = ["https://mortis.cloudflareaccess.com/cdn-cgi/access/callback"]

    access_token_validity = "minutes=5"
    property_mappings = [
        "92b7741f-fde2-457d-a32c-88117620901f",
        "31404244-983e-448d-a848-ced15b0c6f66",
        "38f6abba-95c2-4032-b5b8-c4834f8db70e",
    ]
    signing_key = "f7ca84c2-2ed3-4222-b532-430501ecb657"
}

resource "authentik_application" "cloudflare" {
    name = "Cloudflare"
    slug = "cloudflare"
    group = "OIDC Apps"
    protocol_provider = authentik_provider_oauth2.cloudflare.id
    meta_icon = "https://theme.zdassets.com/theme_assets/184946/28e92aca4bc0f1eb0784c2572768a3b07355f3d5.png"
    meta_description = "Cloudflare Access"
    policy_engine_mode = "any"
}

# Grafana
resource "authentik_provider_oauth2" "grafana" {
    name = "Grafana OIDC"
    client_id = "RX9M4KT3JQeNqGrOAxzNaVaErAf6vVLZM6cYQdQE"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    client_type = "confidential"
    redirect_uris = ["https://monitor.wl.mort.is/login/generic_oauth"]

    access_token_validity = "minutes=5"
    property_mappings = [
        "92b7741f-fde2-457d-a32c-88117620901f",
        "31404244-983e-448d-a848-ced15b0c6f66",
        "38f6abba-95c2-4032-b5b8-c4834f8db70e",
    ]
    signing_key = "f7ca84c2-2ed3-4222-b532-430501ecb657"
}

resource "authentik_application" "grafana" {
    name = "Grafana"
    slug = "grafana"
    group = "Metrics"
    protocol_provider = authentik_provider_oauth2.grafana.id
    meta_icon = "https://grafana.com/static/assets/img/fav32.png"
    meta_launch_url = "https://monitor.wl.mort.is/"
    meta_description = "Kubernetes Dashboard"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "grafana" {
    target = authentik_application.grafana.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

# Kubernetes Dashboard / k8s OIDC
resource "authentik_provider_oauth2" "k8s" {
    name = "Kubernetes OIDC"
    client_id = "ZExFm1fL1IeMu6474ecOvZcm3bTNSKx45JVqPuI9"
    authentication_flow = data.authentik_flow.external_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    client_type = "confidential"
    redirect_uris = [
        "https://k8s.wl.mort.is/oauth2/callback",
        "http://localhost:8000",
    ]

    access_token_validity = "minutes=5"
    property_mappings = [
        "92b7741f-fde2-457d-a32c-88117620901f",
        "31404244-983e-448d-a848-ced15b0c6f66",
        "38f6abba-95c2-4032-b5b8-c4834f8db70e",
    ]
    signing_key = "f7ca84c2-2ed3-4222-b532-430501ecb657"
}

resource "authentik_application" "k8s_dashboard" {
    name = "Kubernetes Dashboard"
    slug = "kube-apiserver"
    group = "Metrics"
    protocol_provider = authentik_provider_oauth2.k8s.id
    meta_icon = "https://kubernetes.io/icons/icon-128x128.png"
    meta_launch_url = "https://k8s.wl.mort.is/"
    meta_description = "Kubernetes Dashboard"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "k8s_dashboard" {
    target = authentik_application.k8s_dashboard.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}
