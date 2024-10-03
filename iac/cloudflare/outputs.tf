output "dc_tunnel_id" {
    value = cloudflare_zero_trust_tunnel_cloudflared.dc.id
}

output "dc_tunnel_secret" {
    value = cloudflare_zero_trust_tunnel_cloudflared.dc.secret
    sensitive = true
}
