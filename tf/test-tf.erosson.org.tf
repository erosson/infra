locals {
  subdomain = "test-tf"
  domain_name = "erosson.org"
  domain = "${local.subdomain}.${local.domain_name}"
}
resource "github_repository" "main" {
  name = local.domain
  homepage_url = local.domain
  license_template = "GPL-3.0"
}
module "test-tf_erosson_org" {
  source = "./github-cloudflare-pages-site"
  subdomain = local.subdomain
  domain_name = local.domain_name
  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70"
  # github_owner = "erosson"
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "true"
    destination_dir = "."
  }
  github_repository = github_repository.main
}

resource "github_repository_file" "index-html" {
  repository = github_repository.main.name
  # depends-on the project makes pushing this file trigger our first deployment
  depends_on = [ github_repository.main, module.test-tf_erosson_org.cloudflare_pages_project ]
  file = "index.html"
  content = <<EOF
<!doctype html>
<html>
<body>
hello, tf-generated-index!
<a href="https://github.com/${github_repository.main.full_name}">github.com/${github_repository.main.full_name}</a>
</body>
</html>
EOF
}