locals {
  subdomain = "test-tf"
  domain_name = "erosson.org"
  domain = "${local.subdomain}.${local.domain_name}"
  domain_slug = replace(local.domain, ".", "-")
  cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
}
data "github_repository" "main" {
  name = local.domain
}
#module "test-tf_erosson_org" {
#  source = "../modules/github-cloudflare-pages-site"
#  subdomain = local.subdomain
#  domain_name = local.domain_name
#  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
#  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
#  build_config = {
#    build_command = "true"
#    destination_dir = "."
#  }
#  github_repository = data.github_repository.main
#}

resource "github_repository_file" "index-html" {
  repository = data.github_repository.main.name
  # depends-on the project makes pushing this file trigger our first deployment
  # depends_on = [ module.test-tf_erosson_org.cloudflare_pages_project ]
  file = "public/index.html"
  content = <<EOF
<!doctype html>
<html>
<body>
hello, tf-generated-index!

<a href="https://github.com/${data.github_repository.main.full_name}">github.com/${data.github_repository.main.full_name}</a>
</body>
</html>
EOF
}
resource "github_repository_file" "action" {
  repository = data.github_repository.main.name
  # depends_on = [ module.test-tf_erosson_org.cloudflare_pages_project ]
  file = ".github/workflows/build.yml"
  content = file("${path.root}/build.yml")
  depends_on = [cloudflare_pages_project.main]
}

resource "cloudflare_pages_project" "main" {
  name = local.domain_slug
  production_branch = "main.release"
  account_id = local.cloudflare_account_id
  build_config {
    build_command = "true"
    destination_dir = "/release"
    root_dir = "/"
  }
  source {
    type = "github"
    config {
      owner = replace(data.github_repository.main.full_name, "/\\/.*$/", "")
      repo_name = data.github_repository.main.name
      production_branch = "main.release"
      preview_branch_includes = ["*.release"]
    }
  }
}
resource "cloudflare_pages_domain" "main" {
  account_id = cloudflare_pages_project.main.account_id
  project_name = cloudflare_pages_project.main.name
  domain = local.domain
  depends_on = [cloudflare_pages_project.main]
}
resource "cloudflare_record" "main" {
  zone_id = local.cloudflare_zone_id
  type = "CNAME"
  name = local.subdomain
  value = "${cloudflare_pages_domain.main.project_name}.pages.dev."
  proxied = true
  depends_on = [cloudflare_pages_domain.main]
}