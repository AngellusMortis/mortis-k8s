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

resource "cloudflare_zero_trust_access_policy" "bypass" {
    account_id = local.account_id
    name = "Bypass"
    decision = "bypass"

    include {
        everyone = true
    }
}
