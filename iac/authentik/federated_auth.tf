data "authentik_flow" "default_source_authentication" {
  slug = "default-source-authentication"
}

data "authentik_flow" "default_enrollment_flow" {
  slug = "default-enrollment-flow"
}

resource "authentik_source_plex" "name" {
    name = "Plex Login"
    slug = "plex-login"
    enabled = true
    user_matching_mode = "email_link"
    user_path_template = "goauthentik.io/sources/%(slug)s"

    # protocol settings
    client_id = "GN5TZa8SirrzGdXC2E2SLDGMLV2aoBUmzJGOQG17"
    plex_token = local.envs.PLEX_TOKEN
    allowed_servers = tolist([
        "620ff9fe2b77454e9dc96aae70f348401759e211"  # plex.wl.mort.is
    ])

    # flow settings
    authentication_flow = data.authentik_flow.default_source_authentication.id
    enrollment_flow = data.authentik_flow.default_enrollment_flow.id
}
