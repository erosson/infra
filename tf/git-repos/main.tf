resource "github_repository" "main" {
  name = "test-tf.erosson.org"
  homepage_url = "test-tf.erosson.org"
  license_template = "GPL-3.0"
  lifecycle {
    # It's actually safe to recreate this specific repo, as it has no commit history other than what terraform does to it.
    # This is important for most git repos, though.
    prevent_destroy = true
  }
}