locals {
  subdomain = "cooking"
  domain_name = "erosson.org"
  domain = "${local.subdomain}.${local.domain_name}"
}
data "github_repository" "main" {
  name = local.domain
}
module "main" {
  source = "../modules/github-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "yarn dist"
    destination_dir = "dist"
  }
  github_repository = data.github_repository.main
}