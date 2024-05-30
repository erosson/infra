terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.20.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.38.0"
    }
    github = {
      source  = "hashicorp/github"
      version = "~> 6.2.1"
    }
  }

  // Not actually amazon S3. cloudflare R2 - aws-S3-compatible.
  // different auth token than the rest of cloudflare: https://dash.cloudflare.com/fed1bc67ffb2f62c6deaa5c7f8f9eb93/r2/api-tokens
  // directions here: https://github.com/hashicorp/terraform/issues/33847#issuecomment-1854605813
  backend "s3" {
    // bucket content: https://dash.cloudflare.com/fed1bc67ffb2f62c6deaa5c7f8f9eb93/r2/default/buckets/erosson-infra
    bucket = "erosson-infra"
    key    = "erosson/infra/static-sites/terraform.tfstate"
    endpoints = { s3 = "https://fed1bc67ffb2f62c6deaa5c7f8f9eb93.r2.cloudflarestorage.com" }
    region = "us-east-1"

    skip_credentials_validation = true
    skip_region_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check = true
    skip_s3_checksum = true
  }
}

variable "CI" {
  type = bool
  default = false
}
# https://github.com/erosson/infra/blob/main/tf/static-sites/provider.tf
variable "GITHUB_TOKEN_INFRA_BUILD_DOCKER_IMAGE" {
  # Other static-site repositories have this secret added to their actions.
  # It allows them to trigger this repository's static-sites workflow.
  # Whenever a "child" static-site is updated, we rebuild and redeploy the combined "parent" image.
  #
  # Why?
  # Dedicated static-site hosts have too many obstacles - creating each project, redirects, poor terraform integration, huge vendor lock-in...
  # S3 or other object-store hosts fall down the moment you have to do redirects or anything remotely fancy.
  # Good old rsync-on-change creates a "pet" server by maintaining state - it's not resilient if that server ever goes down.
  # One docker image per static-site is quite expensive for all webhosts I've looked at; they charge per container.
  # This couples us to Github-actions more tightly, not ideal - but otherwise a combined-static-sites Docker image has been a dream so far!
  # 
  # Created at: https://github.com/settings/personal-access-tokens/3347136
  # https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-dispatch-event
}
provider "digitalocean" {
  # requires env DIGITALOCEAN_TOKEN. https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
}