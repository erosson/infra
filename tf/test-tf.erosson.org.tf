module "test-tf_erosson_org" {
  source = "./github-cloudflare-pages-site"
  subdomain = "test-tf"
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
</body>
</html>
EOF
}
