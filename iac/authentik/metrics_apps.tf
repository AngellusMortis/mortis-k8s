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
    protocol_provider = authentik_provider_proxy.prometheus.id
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
