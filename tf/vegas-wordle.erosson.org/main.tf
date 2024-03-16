locals {
  subdomain = "vegas-wordle"
  domain_name = "erosson.org"
  domain = "${local.subdomain}.${local.domain_name}"
}
data "github_repository" "main" {
  name = "vegas-wordle"
}
module "main" {
  source = "../modules/github-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "yarn build"
    destination_dir = "build"
  }
  github_repository = data.github_repository.main
}