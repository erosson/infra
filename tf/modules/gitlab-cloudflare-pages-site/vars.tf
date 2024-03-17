variable "cloudflare_account_id" {
  description = "Cloudflare account id. Not private."
}
variable "domain_cloudflare_zone_id" {
  description = "Cloudflare domain identifier. Not private. In the Cloudflare UI, select a domain to see its zone id. `domain_name` must match this."
}
variable "domain_name" {
  description = "Domain name. If subdomain is `www` and domain_name is `example.com`, the site will deploy at `www.example.com`. `domain_cloudflare_zone_id` must match this."
}
variable "gitlab_project" {
  type = object({
    path = string
    path_with_namespace = string
  })
}
variable "license_template" {
  default = "GPL-3.0"
}
variable "cloudflare_pages_name" {
  default = null
  description = "Cloudflare pages name. Used for the internal url `<cloudflare_pages_name>.pages.dev`, and in Cloudflare URLs for this site. By default, use a slug based on the full domain name."
}
variable "subdomain" {
  description = "Site name. If subdomain is `www` and domain_name is `example.com`, the site will deploy at `www.example.com`."
}
variable "build_config" {
  # type = cloudflare_pages_project.build_config
  type = object({
    build_command = string
    destination_dir = string
    root_dir = optional(string)
  })
  description = "Cloudflare pages build config."
}
variable "production_branch" {
  type = string
  default = "main"
  description = "Cloudflare production branch"
}