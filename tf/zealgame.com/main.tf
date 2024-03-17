locals {
  subdomain = "www"
  domain_name = "zealgame.com"
  domain = "${local.subdomain}.${local.domain_name}"
  zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
}
data "github_repository" "main" {
  name = "zealgame.com"
}
data "github_repository" "self" {
  name = "infra"
}
module "main" {
  source = "../modules/github-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = local.zone_id
  cloudflare_account_id = local.cloudflare_account_id
  build_config = {
    build_command = "true"
    destination_dir = "public"
  }
  github_repository = data.github_repository.main
  proxied = true
}

# redirect: one-time deploy of the static site under ./redirect/root
# TODO moduleify this
resource "cloudflare_pages_project" "root_redirect" {
  name = "zealgame-com"
  production_branch = "main"
  account_id = local.cloudflare_account_id
}
resource "null_resource" "root_redirect_deploy" {
  depends_on = [ cloudflare_pages_project.root_redirect ]
  lifecycle {
    # TODO trigger if the redirect file changes too
    replace_triggered_by = [ cloudflare_pages_project.root_redirect ]
  }
  provisioner "local-exec" {
    command = "CLOUDFLARE_ACCOUNT_ID=${local.cloudflare_account_id} infisical run -- npx wrangler pages deploy ${path.root}/redirect/root --project-name ${cloudflare_pages_project.root_redirect.name}"
  }
}
resource "cloudflare_pages_domain" "root_redirect" {
  account_id   = local.cloudflare_account_id
  project_name = cloudflare_pages_project.root_redirect.name
  domain       = local.domain_name  # in this case, the bare domain
  depends_on = [cloudflare_pages_project.root_redirect]
}
resource "cloudflare_record" "root_redirect" {
  zone_id = local.zone_id
  type = "CNAME"
  name = "@"  # cloudflare supports CNAME on a bare domain
  value = "${cloudflare_pages_project.root_redirect.name}.pages.dev."
  proxied = true
  depends_on = [cloudflare_pages_project.root_redirect]
}