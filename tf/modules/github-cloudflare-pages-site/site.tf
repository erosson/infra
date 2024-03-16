locals {
  domain = "${var.subdomain}.${var.domain_name}"
  domain_slug = replace(local.domain, ".", "-")
  # github_repo_name = var.github_repo_name != null ? var.github_repo_name : local.domain
  github_repo_name = var.github_repository.name
  github_owner = replace(var.github_repository.full_name, "/\\/.*$/", "")
  cloudflare_pages_name = var.cloudflare_pages_name != null ? var.cloudflare_pages_name : local.domain_slug
}

resource "github_repository_file" "readme-terraform" {
  # repository = github_repository.main.name
  repository = local.github_repo_name
  # depending on cloudflare_pages_project conveniently triggers our first deployment
  depends_on = [ var.github_repository, cloudflare_pages_project.main ]
  file = "${var.build_config.root_dir == null ? "" : "${var.build_config.root_dir}/"}README-tf-cloudflare.md"
  content = <<EOF
Static site and Github repo managed by Evan's Opentofu (Terraform) infrastructure.

* This repository's `.tf` configuration: https://github.com/erosson/infra/tree/main/tf/${local.domain}
* Public site: https://${local.domain}
* Backend site: https://${local.cloudflare_pages_name}.pages.dev
* Deployment status: https://dash.cloudflare.com/${var.cloudflare_account_id}/pages/view/${local.cloudflare_pages_name}

_This file is autogenerated, don't edit_
EOF
  commit_message = "[infra] cloudflare-pages terraform readme"
}

resource "cloudflare_pages_project" "main" {
  name = local.cloudflare_pages_name
  production_branch = var.production_branch
  account_id = var.cloudflare_account_id
  build_config {
    build_command = var.build_config.build_command
    destination_dir = var.build_config.destination_dir
    root_dir = var.build_config.root_dir
  }
  source {
    type = "github"
    config {
      owner = local.github_owner
      repo_name = local.github_repo_name
      production_branch = var.production_branch
    }
  }
  depends_on = [ var.github_repository ]
}

resource "cloudflare_pages_domain" "main" {
  account_id   = var.cloudflare_account_id
  project_name = local.cloudflare_pages_name
  domain       = local.domain
  depends_on = [cloudflare_pages_project.main]
  lifecycle {
    # uncomment me when deleting cloudflare_pages_project
    # replace_triggered_by = [ cloudflare_pages_project.main ]
  }
}

resource "cloudflare_record" "main" {
  zone_id = var.domain_cloudflare_zone_id
  type = "CNAME"
  name = var.subdomain
  value = "${cloudflare_pages_project.main.name}.pages.dev."
  depends_on = [cloudflare_pages_domain.main]
}