locals {
  subdomain = "www"
  domain_name = "zealgame.com"
  domain = "${local.subdomain}.${local.domain_name}"
  zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
}
data "github_repository" "main" {
  name = "zealgame.com"
}
module "main" {
  source = "../modules/github-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = local.zone_id
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "true"
    destination_dir = "public"
  }
  github_repository = data.github_repository.main
  proxied = true
}
resource "cloudflare_record" "root" {
  zone_id = local.zone_id
  type = "CNAME"
  name = "@"
  value = "${module.main.cloudflare_pages_project.name}.pages.dev."
  proxied = true
  depends_on = [module.main]
}