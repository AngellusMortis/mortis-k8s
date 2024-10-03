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
