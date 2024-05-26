resource "digitalocean_app" "main" {
  spec {
    name   = "erosson-infra-static-sites"
    region = "nyc"
    features = ["buildpack-stack=ubuntu-22"]

    service {
      name               = "erosson-public-infra-static-site"
      instance_count     = 1
      instance_size_slug = "apps-s-1vcpu-0.5gb"
      http_port = 80

      image {
        registry_type = "GHCR"
        registry = "erosson"
        repository = "public-infra-static-sites"
        tag = "main"
      }
      health_check {
        http_path = "/healthz"
      }
      env {
        key = "DOMAIN_PREFIX"
        value = "http://"
      }
      env {
        key = "DOMAIN_SUFFIX"
        value = ":80"
      }
    }
    alert {
      disabled = false
      rule = "DEPLOYMENT_FAILED"
    }
    alert {
      disabled = false
      rule = "DOMAIN_FAILED"
    }
    domain { name = "docker-ops.erosson.org" }
    domain { name = "ops.erosson.org" }
    domain { name = "docker-math2.swarmsim.com" }
    domain { name = "docker-cooking.erosson.org" }
    domain { name = "docker-freecbt.erosson.org" }
    domain { name = "docker-vegas-wordle.erosson.org" }
    domain { name = "docker-www.zealgame.com" }
    domain { name = "docker.zealgame.com" }
  }
}

locals {
  erosson_org_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  swarmsim_com_zone_id = "2526e11f0b20a0e69b0fcfb1e5a21d21" // swarmsim.com
  zealgame_com_zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
  cname_value = replace(digitalocean_app.main.default_ingress, "https://", "")
  proxied = "true"
}
resource "cloudflare_record" "ops" {
  zone_id = local.erosson_org_zone_id
  type = "CNAME"
  name = "ops"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "docker-ops" {
  zone_id = local.erosson_org_zone_id
  type = "CNAME"
  name = "docker-ops"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "math2" {
  zone_id = local.swarmsim_com_zone_id
  type = "CNAME"
  name = "docker-math2"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "cooking" {
  zone_id = local.erosson_org_zone_id
  type = "CNAME"
  name = "docker-cooking"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "vegas-wordle" {
  zone_id = local.erosson_org_zone_id
  type = "CNAME"
  name = "docker-vegas-wordle"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "freecbt" {
  zone_id = local.erosson_org_zone_id
  type = "CNAME"
  name = "docker-freecbt"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "zealgame" {
  zone_id = local.zealgame_com_zone_id
  type = "CNAME"
  name = "docker"
  value = local.cname_value
  proxied = local.proxied
}
resource "cloudflare_record" "www-zealgame" {
  zone_id = local.zealgame_com_zone_id
  type = "CNAME"
  name = "docker-www"
  value = local.cname_value
  proxied = local.proxied
}