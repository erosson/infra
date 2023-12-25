variable "cloudflare_account_id" {
  default = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  description = "Cloudflare account id. Not private."
}
variable "cloudflare_zone_id" {
  // default: erosson.org
  default = "7c06b35c2392935ebb0653eaf94a3e70"
  description = "Cloudflare domain identifier. Not private. In the Cloudflare UI, select a domain to see its zone id. `parent_domain` must match this."
}
variable "parent_domain" {
  default = "erosson.org"
  description = "Domain name. If subdomain is `www` and parent_domain is `example.com`, the site will deploy at `www.example.com`. `cloudflare_zone_id` must match this."
}
variable "github_owner" {
  default = "erosson"
  description = "Name of the github repository owner/organization."
}
variable "github_repo_name" {
  default = null
  description = "Github repository name. By default, the site's full domain name."
}
variable "license_template" {
  default = "GPL-3.0"
}
variable "cloudflare_pages_name" {
  default = null
  description = "Cloudflare pages name. Used for the internal url `<cloudflare_pages_name>.pages.dev`, and in Cloudflare URLs for this site. By default, use a slug based on the full domain name."
}
variable "subdomain" {
  description = "Site name. If subdomain is `www` and parent_domain is `example.com`, the site will deploy at `www.example.com`."
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