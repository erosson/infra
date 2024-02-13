# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# $ terraform import github_repository.terraform terraform

resource "github_repository" "test-tf_erosson_org" {
  # https://github.com/erosson/test-tf.erosson.org
  name = "test-tf.erosson.org"
  homepage_url = "test-tf.erosson.org"
  license_template = "GPL-3.0"
  lifecycle {
    # It's actually safe to recreate this specific repo, as it has no commit history other than what terraform does to it.
    # This is important for most git repos, though.
    # prevent_destroy = true
  }
}
resource "github_repository" "math2_swarmsim_com" {
  # https://github.com/erosson/math2.swarmsim.com
  name = "math2.swarmsim.com"
  homepage_url = "math2.swarmsim.com"
  license_template = "GPL-3.0"
  lifecycle {
    prevent_destroy = true
  }
}