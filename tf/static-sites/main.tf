###############################################################################
# Each new site must add a bit of config below.
# These should match the Caddyfile and Dockerfile in `/static-sites`, too.
###############################################################################
locals {
  # generate github-actions secrets for each child repository. Grants permissions to build the combined image.
  # many of them look like domains, but I promise they're repo names. like https://github.com/erosson/math2.swarmsim.com
  github_repositories = [
    "math2.swarmsim.com",
    "cooking.erosson.org",
    "vegas-wordle",
    "freecbt",
    "zealgame.com",
  ]
  # generate dns records and digitalocean-app domain entries
  domains = [
    {sub="docker-ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="docker-math2", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="docker-cooking", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="docker-freecbt", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="docker-vegas-wordle", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="docker-www", domain="zealgame.com", zone_id=local.zealgame_com_zone_id},
    {sub="docker", domain="zealgame.com", zone_id=local.zealgame_com_zone_id},
  ]
}

###############################################################################
# New sites shouldn't need to modify anything after this point.
###############################################################################
locals {
  erosson_org_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  swarmsim_com_zone_id = "2526e11f0b20a0e69b0fcfb1e5a21d21" // swarmsim.com
  zealgame_com_zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
  cname_value = replace(digitalocean_app.main.default_ingress, "https://", "")
  proxied = "true"
  full_domains = [ for d in local.domains: merge(d, {full_domain="${d.sub == "" ? "" : "${d.sub}."}${d.domain}"})]
}

resource "github_actions_secret" "main" {
  for_each = { for index, r in local.github_repositories: r => r }
  repository = each.value
  secret_name = "GH_TOKEN_INFRA_BUILD_DOCKER_IMAGE"
  plaintext_value = var.GITHUB_TOKEN_INFRA_BUILD_DOCKER_IMAGE
}

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

    # we had a long list of these. ugh...!
    # domain { name = "docker-ops.erosson.org"} 

    # this is more complex, but avoids redundancy.
    # thanks, https://www.techtarget.com/searchitoperations/tutorial/Simplify-code-with-for_each-and-dynamic-blocks-in-Terraform#:~:text=In%20Terraform%2C%20dynamic%20blocks%20let,in%20a%20map%20or%20list.
    dynamic "domain" {
      for_each=local.full_domains
      content {
        name = domain.value.full_domain
      }
    }
  }
}

resource "cloudflare_record" "main" {
  # https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12 : "using for_each on a list of objects"
  for_each = { for index, d in local.domains: "${d.sub}.${d.domain}" => d }
  zone_id = each.value.zone_id
  type = "CNAME"
  name = each.value.sub
  value = local.cname_value
  proxied = local.proxied
}