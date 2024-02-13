# Adapted from old terraform config: https://github.com/erosson/wolcendb/blob/1dfe723d4b2f0355773b6cf0aa81ce4bf91159b0/deploy.tf#L4
locals {
  project    = "wolcendb"
  hostdomain = "erosson.org"
  fulldomain = "${local.project}.${local.hostdomain}"
  # img.wolcendb.erosson.org would be nice instead of img-wolcendb.erosson.org, but cloudflare's ssl cert doesn't cover nested subdomains
  img_subdomain      = "img-${local.project}"
  imgdomain          = "${local.img_subdomain}.${local.hostdomain}"
  cloudflare_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" # erosson.org
}

# TODO: netlify's terraform provider is terrible. I don't want to bother migrating though, it's working fine,
# so wolcendb's netlify instance isn't managed by terraform yet.
# https://app.netlify.com/sites/wolcendb/overview

resource "cloudflare_record" "www" {
  zone_id = local.cloudflare_zone_id
  name    = local.project
  type    = "CNAME"
#   value   = module.webhost.dns
  value   = local.project
  proxied = false # netlify does its own proxying
}

# image hosting
resource "aws_s3_bucket" "img" {
  bucket = local.imgdomain
  acl = "private" # avoid root directory listing; policy overrides this for image hosting
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.imgdomain}/*"
            ]
        }
    ]
}
EOF
  cors_rule {
    # allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://wolcendb.erosson.org", "http://localhost:3000", "http://localhost:5000"]
    # expose_headers  = ["ETag"]
    max_age_seconds = 86400
  }
}

resource "cloudflare_record" "img" {
  zone_id = local.cloudflare_zone_id
  name    = local.img_subdomain
  type    = "CNAME"
  value   = aws_s3_bucket.img.bucket_domain_name
  proxied = true
}

# https://community.cloudflare.com/t/firewall-rule-to-block-referers-other-than-the-sites-domain/72115/7
resource "cloudflare_filter" "img" {
  zone_id     = local.cloudflare_zone_id
  description = "img-wolcendb hotlink protection"
  expression  = <<EOF
(http.host eq "img-wolcendb.erosson.org" and http.referer ne "" and not http.referer contains "wolcendb.erosson.org" and not http.referer contains "localhost")
EOF
}

resource "cloudflare_firewall_rule" "img" {
  zone_id     = local.cloudflare_zone_id
  description = "img-wolcendb hotlink protection"
  filter_id   = cloudflare_filter.img.id
  action      = "block"
}