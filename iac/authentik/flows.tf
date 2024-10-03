data "authentik_flow" "external_authentication_flow" {
    slug = "external-authentication-flow"
}

data "authentik_flow" "internal_authentication_flow" {
    slug = "internal-authentication-flow"
}

data "authentik_flow" "default_provider_authorization_implicit_consent" {
    slug = "default-provider-authorization-implicit-consent"
}
