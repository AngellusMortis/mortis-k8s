variable "name" {
    type = string
    description = "Application name"
}

variable "icon" {
    type = string
    description = "URL for icon for application"
    nullable = true
}

variable "account_id" {
    type = string
    description = "Account ID for Access"
}

variable "zone_id" {
    type = string
    description = "Zone ID for DNS"
}

variable "dns_tags" {
    type = list(string)
    description = "Tags for DNS record"
}

variable "tunnel_id" {
    type = string
    description = "Cloudflare Tunnel ID"
}

variable "second_subdomain" {
    type = string
    description = "Second level subdomain for app"
    nullable = true
}

variable "base_domain" {
    type = string
    description = "Top level domain"
}

variable "idps" {
    type = list(string)
    description = "List of allowed IDP IDs"
}

variable "policies" {
    type = list(string)
    description = "List of policy IDs"
}

variable "subdomain" {
    type = string
    description = "Parent subdomain for app"
    default = "wl"
}
