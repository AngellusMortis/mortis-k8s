data "authentik_flow" "internal_authentication_flow" {
    slug = "internal-authentication-flow"
}

data "authentik_flow" "default_provider_authorization_implicit_consent" {
    slug = "default-provider-authorization-implicit-consent"
}


resource "authentik_provider_proxy" "provider" {
    count = var.create_provider ? 1 : 0

    name = "Provider for ${var.name}"
    authentication_flow = var.authentication_flow == "" ? data.authentik_flow.internal_authentication_flow.id : var.authentication_flow
    authorization_flow = var.authorization_flow == "" ? data.authentik_flow.internal_authentication_flow.id : var.authorization_flow
    mode = "forward_domain"

    external_host = "https://auth.${var.base_domain}/"
    cookie_domain = var.base_domain
    access_token_validity = var.session_length
}

resource "authentik_application" "application" {
    name = var.name
    slug = var.slug
    group = var.group
    protocol_provider = var.create_provider ? authentik_provider_proxy.provider[0].id : null
    meta_icon = var.icon
    meta_launch_url = "https://${var.subdomain}.${var.base_domain}${var.path}"
    meta_description = var.description
    open_in_new_tab = true
    policy_engine_mode = "any"
}

resource "authentik_policy_binding" "group_policy" {
    target = authentik_application.application.uuid
    group  = var.user_group
    order  = 0
}
