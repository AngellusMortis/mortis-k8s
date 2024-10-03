resource "random_bytes" "tunnel_secret" {
  length = 128
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "dc" {
    account_id = local.account_id
    name = "dc.mort.is"
    secret = random_bytes.tunnel_secret.base64
    config_src = "local"
}
