resource "cloudflare_record" "root" {
    zone_id = cloudflare_zone.mortis.id
    name = "@"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.unused)
}

resource "cloudflare_record" "wl_root" {
    zone_id = cloudflare_zone.mortis.id
    name = "wl"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.wl, local.tags.unused)
}

resource "cloudflare_record" "links" {
    zone_id = cloudflare_zone.mortis.id
    name = "l"
    proxied = true
    content = "${cloudflare_zero_trust_tunnel_cloudflared.wl.id}.cfargotunnel.com"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.page_rule, local.tags.misc)
}

resource "cloudflare_record" "protonmail1" {
    zone_id = cloudflare_zone.mortis.id
    name = "protonmail._domainkey"
    proxied = false
    content = "protonmail.domainkey.deqmg2zd2ai6pi7drhr7lhw4kom7xw55wkzo2rl5cfppqvjcxsbla.domains.proton.ch"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "protonmail2" {
    zone_id = cloudflare_zone.mortis.id
    name = "protonmail2._domainkey"
    proxied = false
    content = "protonmail2.domainkey.deqmg2zd2ai6pi7drhr7lhw4kom7xw55wkzo2rl5cfppqvjcxsbla.domains.proton.ch"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "protonmail3" {
    zone_id = cloudflare_zone.mortis.id
    name = "protonmail3._domainkey"
    proxied = false
    content = "protonmail3.domainkey.deqmg2zd2ai6pi7drhr7lhw4kom7xw55wkzo2rl5cfppqvjcxsbla.domains.proton.ch"
    type = "CNAME"
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "mx1" {
    zone_id = cloudflare_zone.mortis.id
    name = "@"
    proxied = false
    content = "mailsec.protonmail.ch"
    type = "MX"
    priority = 20
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "mx2" {
    zone_id = cloudflare_zone.mortis.id
    name = "@"
    proxied = false
    content = "mail.protonmail.ch"
    type = "MX"
    priority = 10
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "dmarc" {
    zone_id = cloudflare_zone.mortis.id
    name = "_dmarc"
    proxied = false
    content = "v=DMARC1; p=none; rua=mailto:dmarc@mort.is;"
    type = "TXT"
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "spf" {
    zone_id = cloudflare_zone.mortis.id
    name = "@"
    proxied = false
    content = "v=spf1 include:_spf.protonmail.ch ~all"
    type = "TXT"
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "proton_verify" {
    zone_id = cloudflare_zone.mortis.id
    name = "@"
    proxied = false
    content = "protonmail-verification=5004d5cae00b8de508c7a3cb63cb4f847abc93c1"
    type = "TXT"
    tags = concat(local.tags.all, local.tags.email)
}

resource "cloudflare_record" "ms" {
    zone_id = cloudflare_zone.mortis.id
    name = "@"
    proxied = false
    content = "MS=ms16075789"
    type = "TXT"
    tags = concat(local.tags.all, local.tags.email)
}
