## Outposts
resource "authentik_outpost" "dc_outpost" {
    name = "authentik dc outpost"
    type = "proxy"
    service_connection = "318a42a5-e979-441a-b57d-c06e37fa7b7c"  # local k8s cluster integration
    protocol_providers = [
        module.dc_apps["syncthing-backup"].provider_id
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
