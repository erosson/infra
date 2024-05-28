# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# $ ./tofu import github_repository.terraform terraform

resource "github_repository" "math2_swarmsim_com" {
  # https://github.com/erosson/math2.swarmsim.com
  name = "math2.swarmsim.com"
  homepage_url = "https://math2.swarmsim.com"
  license_template = "GPL-3.0"
  lifecycle {
    prevent_destroy = true
  }
}
resource "github_repository" "wolcendb" {
  # https://github.com/erosson/wolcendb
  name = "wolcendb"
  homepage_url = "https://wolcendb.erosson.org"
  license_template = "GPL-3.0"
  lifecycle {
    prevent_destroy = true
  }
}
resource "github_repository" "cooking_erosson_org" {
  # https://github.com/erosson/wolcendb
  name = "recipes"
  homepage_url = "https://cooking.erosson.org"
  license_template = "GPL-3.0"
  lifecycle {
    prevent_destroy = true
  }
}