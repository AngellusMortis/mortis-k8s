output "cloudflare_oidc_client_id" {
    value = authentik_provider_oauth2.cloudflare.client_id
    sensitive = false
}

output "cloudflare_oidc_client_secret" {
    value = authentik_provider_oauth2.cloudflare.client_secret
    sensitive = true
}

output "k8s_oidc_client_id" {
    value = authentik_provider_oauth2.k8s.client_id
    sensitive = false
}

output "k8s_oidc_client_secret" {
    value = authentik_provider_oauth2.k8s.client_secret
    sensitive = true
}

output "grafana_oidc_client_id" {
    value = authentik_provider_oauth2.grafana.client_id
    sensitive = false
}

output "grafana_oidc_client_secret" {
    value = authentik_provider_oauth2.grafana.client_secret
    sensitive = true
}
