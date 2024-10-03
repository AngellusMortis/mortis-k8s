data "authentik_user" "cbailey" {
    username = "cbailey"
}

data "authentik_user" "sbailey" {
    username = "sbailey"
}

resource "authentik_group" "all_users" {
    name = "All Users"
    is_superuser = false
    attributes = jsonencode({
        "notes": "Group containing all users."
    })
    users = [
        data.authentik_user.cbailey.id,
        data.authentik_user.sbailey.id,
    ]
}

resource "authentik_group" "admin_users" {
    name = "Admin Users"
    is_superuser = true
    parent = authentik_group.all_users.id
    attributes = jsonencode({
        "notes": "Group containing admin users."
    })
    users = [
        data.authentik_user.cbailey.id,
    ]
}

resource "authentik_group" "home_users" {
    name = "Home Users"
    is_superuser = false
    parent = authentik_group.all_users.id
    attributes = jsonencode({
        "notes": "Group containing users with access home services."
    })
    users = [
        data.authentik_user.cbailey.id,
        data.authentik_user.sbailey.id,
    ]
}

resource "authentik_group" "media_users" {
    name = "Media Users"
    is_superuser = false
    parent = authentik_group.all_users.id
    attributes = jsonencode({
        "notes": "Group containing users with access media services."
    })
    users = [
        data.authentik_user.cbailey.id,
        data.authentik_user.sbailey.id,
    ]
}

resource "authentik_group" "ssh_users" {
    name = "SSH Users"
    is_superuser = false
    parent = authentik_group.all_users.id
    attributes = jsonencode({
        "notes": "Group containg users with SSH access."
    })
    users = [
        data.authentik_user.cbailey.id,
    ]
}

resource "authentik_group" "media_ingest" {
    name = "Media Ingest Users"
    is_superuser = false
    parent = authentik_group.media_users.id
    attributes = jsonencode({
        "notes": "Group of users with access to media ingestion services."
    })
    users = [
        data.authentik_user.cbailey.id,
        data.authentik_user.sbailey.id,
    ]
}

resource "authentik_group" "api_server_admin" {
    name = "api-server-admin"
    is_superuser = false
    parent = authentik_group.admin_users.id
    attributes = jsonencode({
        "notes": "Group of users with admin access over k8s cluster."
    })
    users = [
        data.authentik_user.cbailey.id,
    ]
}

# resource "authentik_group" "groups" {
#     count = length(local.groups)

#     name = local.groups[count.index].name
#     parent = local.groups[count.index].parent
#     is_superuser = local.groups[count.index].is_superuser
# }
