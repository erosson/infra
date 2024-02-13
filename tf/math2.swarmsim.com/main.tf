locals {
  subdomain = "math2"
  domain_name = "swarmsim.com"
  domain = "${local.subdomain}.${local.domain_name}"
}
data "github_repository" "main" {
  name = local.domain
}
module "math2_swarmsim_com" {
  source = "../modules/github-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = "2526e11f0b20a0e69b0fcfb1e5a21d21" // swarmsim.com
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "yarn build"
    destination_dir = "build"
  }
  github_repository = data.github_repository.main
}