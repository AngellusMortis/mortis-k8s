variable "cloudflare_oidc_client_id" {
    type = string
    description = "Authentik Client ID for the Cloudflare"
    sensitive = false
}

variable "cloudflare_oidc_client_secret" {
    type = string
    description = "Authentik Client Secret for the Cloudflare"
    sensitive = true
}
