module "test-tf_erosson_org" {
  source = "./github-cloudflare-pages-site"
  subdomain = "test-tf"
  domain_name = "erosson.org"
  domain_cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70"
  github_owner = "erosson"
  cloudflare_account_id = "fed1bc67ffb2f62c6deaa5c7f8f9eb93"
  build_config = {
    build_command = "true"
    destination_dir = "."
  }
}

resource "github_repository_file" "index-html" {
  repository = module.test-tf_erosson_org.github_repository.name
  # depends-on the project makes pushing this file trigger our first deployment
  depends_on = [ module.test-tf_erosson_org.github_repository, module.test-tf_erosson_org.cloudflare_pages_project ]
  file = "index.html"
  content = <<EOF
<!doctype html>
<html>
<body>
hello, tf-generated-index!
<a href="https://github.com/${module.test-tf_erosson_org.github_repository.full_name}">github.com/${module.test-tf_erosson_org.github_repository.full_name}</a>
</body>
</html>
EOF
}
