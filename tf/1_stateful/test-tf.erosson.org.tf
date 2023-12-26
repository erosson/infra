locals {
  subdomain = "test-tf"
  domain_name = "erosson.org"
  domain = "${local.subdomain}.${local.domain_name}"
}
resource "github_repository" "main" {
  name = local.domain
  homepage_url = local.domain
  license_template = "GPL-3.0"
  lifecycle {
    prevent_destroy = true
  }
}