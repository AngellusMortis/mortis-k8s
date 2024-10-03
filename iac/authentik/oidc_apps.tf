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
