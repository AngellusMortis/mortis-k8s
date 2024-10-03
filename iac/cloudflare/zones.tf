resource "cloudflare_zone" "mortis" {
    account_id = local.account_id
    zone = "mort.is"
    plan = "pro"
    type = "full"
}

# resource "cloudflare_zone_settings_override" "settings" {
#     zone_id = cloudflare_zone.mortis.id
#     settings {
#         always_online = "off"
#         always_use_https = "on"
#         automatic_https_rewrites = "on"
#         binary_ast = "off"
#         brotli = "on"
#         browser_cache_ttl = 14400
#         browser_check = "on"
#         cache_level = "aggressive"
#         challenge_ttl = 1800
#         ciphers = []
#         cname_flattening = "flatten_at_root"
#         development_mode = "off"
#         early_hints = "on"
#         email_obfuscation = "on"
#         filter_logs_to_cloudflare = "off"
#         fonts = "on"
#         h2_prioritization = "on"
#         hotlink_protection = "on"
#         http2 = "on"
#         http3 = "on"
#         # image_resizing = "off"
#         ip_geolocation = "on"
#         ipv6 = "on"
#         log_to_cloudflare = "on"
#         max_upload = 100
#         min_tls_version = "1.2"
#         mirage = "on"
#         opportunistic_encryption = "on"
#         opportunistic_onion = "on"
#         orange_to_orange = "off"
#         origin_error_page_pass_thru = "off"
#         origin_max_http_version = "2"
#         polish = "lossless"
#         # prefetch_preload = "off"
#         privacy_pass = "on"
#         proxy_read_timeout = "100"
#         pseudo_ipv4 = "off"
#         replace_insecure_js = "off"
#         response_buffering = "off"
#         rocket_loader = "on"
#         security_level = "high"
#         server_side_exclude = "on"
#         sort_query_string_for_cache = "off"
#         speed_brain = "on"
#         ssl = "full"
#         tls_1_3 = "zrt"
#         # true_client_ip_header = "off"
#         visitor_ip = "on"
#         waf = "off"
#         webp = "off"
#         websockets = "on"
#         zero_rtt = "on"

#         nel {
#             enabled = true
#         }

#         security_header {
#             enabled = true
#             max_age = 15768000
#             include_subdomains = false
#             nosniff = true
#             preload = false
#         }
#     }
# }
