variable "name" {
    type = string
    description = "Name for the application"
}

variable "slug" {
    type = string
    description = "Slug for the application"
}

variable "group" {
    type = string
    description = "Group for the application"
}

variable "icon" {
    type = string
    description = "URL to icon for application"
}

variable "subdomain" {
    type = string
    description = "Subdomain for the application"
}

variable "description" {
    type = string
    description = "Description for the application"
}

variable "user_group" {
    type = string
    description = "Group to granted access to"
}

variable "path" {
    type = string
    description = "URL Path for applciation"
    default = "/"
}

variable "create_provider" {
    type = bool
    description = "Create provider for app"
    default = true
}

variable "authentication_flow" {
    type = string
    description = "Authentication flow for the application"
    default = ""
}

variable "authorization_flow" {
    type = string
    description = "Authentication flow for the application"
    default = ""
}

variable "base_domain" {
    type = string
    description = "Base domain for auth/service"
    default = "wl.mort.is"
}

variable "session_length" {
    type = string
    description = "Session length"
    default = "hours=168"
}
