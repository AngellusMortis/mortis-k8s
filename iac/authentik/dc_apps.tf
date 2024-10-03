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
