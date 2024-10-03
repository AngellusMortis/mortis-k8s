output "provider_id" {
    value = var.create_provider ? authentik_provider_proxy.provider[0].id : null
}
