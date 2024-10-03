output "dc_tunnel_id" {
    value = cloudflare_zero_trust_tunnel_cloudflared.dc.id
    sensitive = false
}

output "dc_tunnel_secret" {
    value = cloudflare_zero_trust_tunnel_cloudflared.dc.secret
    sensitive = true
}

output "wl_tunnel_id" {
    value = cloudflare_zero_trust_tunnel_cloudflared.dc.id
    sensitive = false
}

output "wl_tunnel_secret" {
    value = cloudflare_zero_trust_tunnel_cloudflared.dc.secret
    sensitive = true
}

output "uptime_robot_token_id" {
    value = cloudflare_zero_trust_access_service_token.uptime_robot.client_id
    sensitive = false
}

output "uptime_robot_token_secret" {
    value = cloudflare_zero_trust_access_service_token.uptime_robot.client_secret
    sensitive = true
}
