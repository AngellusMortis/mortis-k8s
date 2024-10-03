resource "random_bytes" "dc_tunnel_secret" {
    length = 128
}

resource "random_bytes" "wl_tunnel_secret" {
    length = 128
}

# resource "cloudflare_zero_trust_tunnel_cloudflared" "wl" {
#     account_id = local.account_id
#     name = "wl.mort.is"
#     secret = random_bytes.wl_tunnel_secret.base64
#     config_src = "local"
# }

resource "cloudflare_zero_trust_tunnel_cloudflared" "dc" {
    account_id = local.account_id
    name = "dc.mort.is"
    secret = random_bytes.dc_tunnel_secret.base64
    config_src = "local"
}
