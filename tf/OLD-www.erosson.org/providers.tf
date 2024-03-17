provider "aws" {
  version = "~> 1.24"
  region  = "us-east-1"
}

provider "cloudflare" {
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend.erosson.org"
    key    = "erosson.org"
    region = "us-east-1"
  }
}

# for all of my subdomains
resource "cloudflare_zone_settings_override" "erosson_org" {
  name = "erosson.org"

  settings {
    always_use_https = "on"
  }
}

resource "cloudflare_zone_settings_override" "erosson_com" {
  name = "erosson.com"

  settings {
    always_use_https = "on"
  }
}
