resource "cloudflare_zero_trust_access_policy" "allow_admin_users" {
    account_id = local.account_id
    name = "Allow Admin Users"
    decision = "allow"

    include {
        group = [cloudflare_zero_trust_access_group.admin_users.id]
    }

    require {
        group = [cloudflare_zero_trust_access_group.admin_users.id]
    }
}

resource "cloudflare_zero_trust_access_policy" "allow_home_users" {
    account_id = local.account_id
    name = "Allow Home Users"
    decision = "allow"

    include {
        group = [cloudflare_zero_trust_access_group.home_users.id]
    }

    require {
        group = [cloudflare_zero_trust_access_group.home_users.id]
    }
}

resource "cloudflare_zero_trust_access_policy" "allow_media_ingest_users" {
    account_id = local.account_id
    name = "Allow Media Ingest Users"
    decision = "allow"

    include {
        group = [cloudflare_zero_trust_access_group.media_ingest_users.id]
    }

    require {
        group = [cloudflare_zero_trust_access_group.media_ingest_users.id]
    }
}


resource "cloudflare_zero_trust_access_policy" "allow_ssh_users" {
    account_id = local.account_id
    name = "Allow SSH Users"
    decision = "allow"

    include {
        group = [cloudflare_zero_trust_access_group.ssh_users.id]
    }

    require {
        group = [cloudflare_zero_trust_access_group.ssh_users.id]
    }
}

resource "cloudflare_zero_trust_access_policy" "bypass" {
    account_id = local.account_id
    name = "Bypass"
    decision = "bypass"

    include {
        everyone = true
    }
}
