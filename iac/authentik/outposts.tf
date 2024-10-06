resource "authentik_outpost" "embedded" {
    name = "authentik Embedded Outpost"
    type = "proxy"
    service_connection = "318a42a5-e979-441a-b57d-c06e37fa7b7c"  # local k8s cluster integration
    protocol_providers = [
        module.control_apps["longhorn"].provider_id,
        module.control_apps["crashplan"].provider_id,
        module.control_apps["unifi-network"].provider_id,
        module.control_apps["fluxcd"].provider_id,
        module.home_apps["birdnet"].provider_id,
        module.home_apps["home-assistant"].provider_id,
        module.home_apps["paperless"].provider_id,
        module.home_apps["span"].provider_id,
        module.home_apps["unifi-protect"].provider_id,
        module.home_apps["enphase-envoy"].provider_id,
        module.home_apps["valetudo-ground-floor"].provider_id,
        module.home_apps["syncthing"].provider_id,
        module.media_ingest_apps["bazarr"].provider_id,
        module.media_ingest_apps["deluge"].provider_id,
        module.media_ingest_apps["radarr"].provider_id,
        module.media_ingest_apps["prowlarr"].provider_id,
        module.media_ingest_apps["sonarr"].provider_id,
        module.media_ingest_apps["fileflows"].provider_id,
        module.media_ingest_apps["autobrr"].provider_id,
        module.media_ingest_apps["lidarr"].provider_id,
        module.metrics_apps["alert-manager"].provider_id,
        module.metrics_apps["prometheus"].provider_id,
    ]
    config = jsonencode({
        "log_level": "info",
        "docker_labels": null,
        "authentik_host": "https://auth.wl.mort.is/",
        "docker_network": null,
        "container_image": null,
        "docker_map_ports": true,
        "refresh_interval": "minutes=5",
        "kubernetes_replicas": 1,
        "kubernetes_namespace": "auth",
        "authentik_host_browser": "https://auth.wl.mort.is/",
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

resource "authentik_outpost" "dc_outpost" {
    name = "authentik dc outpost"
    type = "proxy"
    service_connection = "318a42a5-e979-441a-b57d-c06e37fa7b7c"  # local k8s cluster integration
    protocol_providers = [
        module.dc_apps["download-backup"].provider_id,
        module.dc_apps["syncthing-backup"].provider_id,
    ]
    config = jsonencode({
        "log_level": "info",
        "docker_labels": null,
        "authentik_host": "https://auth.dc.mort.is/",
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
