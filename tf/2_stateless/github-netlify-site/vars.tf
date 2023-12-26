variable "cloudflare_account_id" {
  description = "Cloudflare account id. Not private."
}
variable "domain_cloudflare_zone_id" {
  description = "Cloudflare domain identifier. Not private. In the Cloudflare UI, select a domain to see its zone id. `domain_name` must match this."
}
variable "domain_name" {
  description = "Domain name. If subdomain is `www` and domain_name is `example.com`, the site will deploy at `www.example.com`. `domain_cloudflare_zone_id` must match this."
}
variable "github_repository" {
  type = object({
    name = string
    full_name = string
  })
}
variable "license_template" {
  default = "GPL-3.0"
}
variable "netlify_name" {
  default = null
  description = "Netlify name. Used for the internal url `<cloudflare_pages_name>.netlify.app`, and in Cloudflare URLs for this site. By default, use a slug based on the full domain name."
}
variable "subdomain" {
  description = "Site name. If subdomain is `www` and domain_name is `example.com`, the site will deploy at `www.example.com`."
}
variable "repo" {
  type = object({
    command = string
    dir = string
  })
  description = "Netlify build config."
}