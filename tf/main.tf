terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.20.0"
    }
  }
}

provider "github" {}
provider "cloudflare" {}
