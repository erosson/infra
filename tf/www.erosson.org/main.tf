locals {
  subdomain = "cf-www"
  piano_subdomain = "cf-piano"
  domain_name = "erosson.org"
  domain = "${local.subdomain}.${local.domain_name}"
}
data "gitlab_project" "main" {
  path_with_namespace = "erosson/erosson-org"
}
module "main" {
  source = "../modules/gitlab-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  production_branch = "master"
  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "yarn build"
    destination_dir = "dist"
  }
  gitlab_project = data.gitlab_project.main
}
# NOPE, one cloudflare project per git repo. no monorepos.
# module "piano" {
#   source = "../modules/gitlab-cloudflare-pages-site"
#   subdomain = local.piano_subdomain
#   domain_name = local.domain_name
#   production_branch = "master"
#   domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
#   cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
#   build_config = {
#     build_command = "yarn build"
#     destination_dir = "dist/piano"
#   }
#   gitlab_project = data.gitlab_project.main
# }