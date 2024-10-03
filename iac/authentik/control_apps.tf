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
