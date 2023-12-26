locals {
  netlify_subdomain = "test-tf-netlify"
  netlify_domain = "${local.netlify_subdomain}.${local.domain_name}"
}
module "test-tf-netlify_erosson_org" {
  source = "./github-netlify-site"
  subdomain = local.netlify_subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70"
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  repo = {
    command = "true"
    dir = "."
  }
  github_repository = data.github_repository.main
}