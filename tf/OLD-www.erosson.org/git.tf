# The git repository this all lives in.
provider "gitlab" {
  version = "~> 1.0"
}

resource "gitlab_project" "git" {
  name             = "erosson.org"
  description      = "https://www.erosson.org and related sites"
  visibility_level = "private"
  default_branch   = "master"

  provisioner "local-exec" {
    command = <<EOF
sh -eu
git remote remove origin || true
git remote add origin ${gitlab_project.git.ssh_url_to_repo}
git push -u origin master
EOF
  }
}
