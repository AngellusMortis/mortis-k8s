data "authentik_flow" "external_authentication_flow" {
    slug = "external-authentication-flow"
}

data "authentik_flow" "internal_authentication_flow" {
    slug = "internal-authentication-flow"
}

data "authentik_flow" "default_provider_authorization_implicit_consent" {
    slug = "default-provider-authorization-implicit-consent"
}

## WL Apps
## OIDC Apps
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

## Control Apps
# Longhorn
resource "authentik_provider_proxy" "longhorn" {
    name = "Provider for Longhorn"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.wl.mort.is"
    cookie_domain = "wl.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "longhorn" {
    name = "Longhorn"
    slug = "longhorn"
    group = "Control"
    protocol_provider = authentik_provider_proxy.longhorn.id
    meta_icon = "https://longhorn.io/img/logos/longhorn-icon-color.png"
    meta_launch_url = "https://longhorn.wl.mort.is/"
    meta_description = "Kubernetes Storage Backend UI"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "longhorn" {
    target = authentik_application.longhorn.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

# CrashPlan
resource "authentik_provider_proxy" "crashplan" {
    name = "Provider for CrashPlan"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.wl.mort.is"
    cookie_domain = "wl.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "crashplan" {
    name = "CrashPlan"
    slug = "crashplan"
    group = "Control"
    protocol_provider = authentik_provider_proxy.crashplan.id
    meta_icon = "https://www.crashplan.com/wp-content/uploads/CrashPlan-Favicon.png"
    meta_launch_url = "https://backup.wl.mort.is/"
    meta_description = "Backup service"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "crashplan" {
    target = authentik_application.crashplan.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

# UniFi Network
resource "authentik_provider_proxy" "ui_network" {
    name = "Provider for UniFi Network"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.wl.mort.is"
    cookie_domain = "wl.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "ui_network" {
    name = "UniFi Network"
    slug = "unifi-network"
    group = "Control"
    protocol_provider = authentik_provider_proxy.ui_network.id
    meta_icon = "https://content-cdn.svc.ui.com/static/favicon.ico"
    meta_launch_url = "https://network.wl.mort.is/"
    meta_description = "UniFi Network Controller"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "ui_network" {
    target = authentik_application.ui_network.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

# FluxCD
resource "authentik_provider_proxy" "fluxcd" {
    name = "Provider for FluxCD"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.wl.mort.is/"
    cookie_domain = "wl.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "fluxcd" {
    name = "FluxCD"
    slug = "fluxcd"
    group = "Control"
    protocol_provider = authentik_provider_proxy.fluxcd.id
    meta_icon = "https://fluxcd.io/favicons/favicon-32x32.png"
    meta_launch_url = "https://cd.wl.mort.is/"
    meta_description = "UniFi Network Controller"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "fluxcd" {
    target = authentik_application.fluxcd.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

## Metrics Apps
# Alert Manager
resource "authentik_provider_proxy" "alert_manager" {
    name = "Provider for Alert Manager"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.wl.mort.is/"
    cookie_domain = "wl.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "alert_manager" {
    name = "Alert Manager"
    slug = "alert-manager"
    group = "Metrics"
    protocol_provider = authentik_provider_proxy.alert_manager.id
    meta_icon = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
    meta_launch_url = "https://alerts.wl.mort.is/"
    meta_description = "Alert Manager"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "alert_manager" {
    target = authentik_application.alert_manager.uuid
    group  = authentik_group.admin_users.id
    order  = 0
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

# Prometheus
resource "authentik_provider_proxy" "prometheus" {
    name = "Provider for Prometheus"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.wl.mort.is/"
    cookie_domain = "wl.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "prometheus" {
    name = "Prometheus"
    slug = "prometheus"
    group = "Metrics"
    protocol_provider = authentik_provider_proxy.alert_manager.id
    meta_icon = "https://prometheus.io/assets/favicons/android-chrome-192x192.png"
    meta_launch_url = "https://prometheus.wl.mort.is/"
    meta_description = "Metric Scraper"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "prometheus" {
    target = authentik_application.prometheus.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

## Media Apps
# Plex
resource "authentik_application" "plex" {
    name = "Plex"
    slug = "plex"
    group = "Media"
    protocol_provider = null
    meta_icon = "https://www.plex.tv/wp-content/themes/plex/assets/img/favicons/plex-180.png"
    meta_launch_url = "https://plex.wl.mort.is/"
    meta_description = "Media Streaming Server"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "plex" {
    target = authentik_application.plex.uuid
    group  = authentik_group.media_users.id
    order  = 0
}

# Overseer
resource "authentik_application" "overseer" {
    name = "Overseer"
    slug = "overseer"
    group = "Media"
    protocol_provider = null
    meta_icon = "https://overseerr.dev/favicon.ico"
    meta_launch_url = "https://media.wl.mort.is/"
    meta_description = "Media Requester"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "overseer" {
    target = authentik_application.overseer.uuid
    group  = authentik_group.media_users.id
    order  = 0
}

## DC Apps
# SyncThing (Backup)
resource "authentik_provider_proxy" "dc_syncthing" {
    name = "Provider for SyncThing (Backup)"
    authentication_flow = data.authentik_flow.internal_authentication_flow.id
    authorization_flow = data.authentik_flow.default_provider_authorization_implicit_consent.id
    mode = "forward_domain"

    external_host = "https://auth.dc.mort.is"
    cookie_domain = "dc.mort.is"
    access_token_validity = "hours=168"
}

resource "authentik_application" "dc_syncthing" {
    name = "SyncThing (Backup)"
    slug = "syncthing-backup"
    group = "Media"
    protocol_provider = authentik_provider_proxy.dc_syncthing.id
    meta_icon = "https://syncthing.net/img/favicons/apple-touch-icon-152x152.png"
    meta_launch_url = "https://sync.dc.wl.mort.is/"
    meta_description = "File Sync Application"
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "dc_syncthing" {
    target = authentik_application.dc_syncthing.uuid
    group  = authentik_group.admin_users.id
    order  = 0
}

## Outposts
resource "authentik_outpost" "dc_outpost" {
    name = "authentik dc outpost"
    type = "proxy"
    service_connection = "318a42a5-e979-441a-b57d-c06e37fa7b7c"  # local k8s cluster integration
    protocol_providers = [
        authentik_provider_proxy.dc_syncthing.id
    ]
    config = jsonencode({
        "log_level": "info",
        "docker_labels": null,
        "authentik_host": "https://authentik-server/",
        "docker_network": null,
        "container_image": null,
        "docker_map_ports": true,
        "refresh_interval": "minutes=5",
        "kubernetes_replicas": 1,
        "kubernetes_namespace": "auth",
        "authentik_host_browser": "https://auth.dc.mort.is/",
        "object_naming_template": "ak-outpost-%(name)s",
        "authentik_host_insecure": true,
        "kubernetes_json_patches": null,
        "kubernetes_service_type": "ClusterIP",
        "kubernetes_image_pull_secrets": [],
        "kubernetes_ingress_class_name": null,
        "kubernetes_disabled_components": [],
        "kubernetes_ingress_annotations": {},
        "kubernetes_ingress_secret_name": "authentik-outpost-tls",
    })
}
