###############################################################################
# Each new site must add a bit of config below.
# These should match the Caddyfile and Dockerfile in `/static-sites`, too.
###############################################################################
locals {
  # generate github-actions secrets for each child repository. Grants permissions to build the combined image.
  # many of them look like domains, but I promise they're repo names. like https://github.com/erosson/math2.swarmsim.com
  github_repositories = [
    "math2.swarmsim.com",
    "math.swarmsim.com",
    "cooking.erosson.org",
    "vegas-wordle",
    "freecbt",
    "zealgame.com",
    "../swarmsim/swarm",
    # TODO: `/s3/buckets/www.erosson.org` still exists. once we're confident in this new docker hosting, delete it
    "erosson.org",
  ]
  # generate dns records and digitalocean-app domain entries
  # TODO: digitalocean-apps have a limit of 40 domain names. unacceptable! find a new host?
  domains = [
    {sub="docker-ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="", domain="swarmsimulator.com", zone_id=local.swarmsimulator_com_zone_id},
    {sub="www", domain="swarmsimulator.com", zone_id=local.swarmsimulator_com_zone_id},
    {sub="", domain="erosson.com", zone_id=local.erosson_com_zone_id},
    {sub="www", domain="erosson.com", zone_id=local.erosson_com_zone_id},
    {sub="", domain="erosson.us", zone_id=local.erosson_us_zone_id},
    {sub="www", domain="erosson.us", zone_id=local.erosson_us_zone_id},
    {sub="", domain="evanrosson.com", zone_id=local.evanrosson_com_zone_id},
    {sub="www", domain="evanrosson.com", zone_id=local.evanrosson_com_zone_id},
    {sub="", domain="evanrosson.org", zone_id=local.evanrosson_org_zone_id},
    {sub="www", domain="evanrosson.org", zone_id=local.evanrosson_org_zone_id},
    {sub="", domain="xmarkedgame.com", zone_id=local.xmarkedgame_com_zone_id},
    {sub="www", domain="xmarkedgame.com", zone_id=local.xmarkedgame_com_zone_id},
    {sub="docker-math", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="docker-www", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="docker", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="docker-preprod", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="math", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="", domain="warswarm.com", zone_id=local.warswarm_com_zone_id},
    {sub="www", domain="warswarm.com", zone_id=local.warswarm_com_zone_id},
    {sub="news", domain="warswarm.com", zone_id=local.warswarm_com_zone_id},
    {sub="", domain="war-swarms.com", zone_id=local.war_swarms_com_zone_id},
    {sub="www", domain="war-swarms.com", zone_id=local.war_swarms_com_zone_id},
    {sub="news", domain="war-swarms.com", zone_id=local.war_swarms_com_zone_id},
    {sub="www", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="www", domain="zealgame.com", zone_id=local.zealgame_com_zone_id},
    {sub="", domain="zealgame.com", zone_id=local.zealgame_com_zone_id},
    {sub="math2", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="freecbt", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="cooking", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="vegas-wordle", domain="erosson.org", zone_id=local.erosson_org_zone_id},
  ]
}

###############################################################################
# New sites shouldn't need to modify anything after this point.
###############################################################################
locals {
  erosson_org_zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  swarmsim_com_zone_id = "2526e11f0b20a0e69b0fcfb1e5a21d21" // swarmsim.com
  zealgame_com_zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
  // redirects
  swarmsimulator_com_zone_id = "d13b76f838ab1e82ed4c822138edfba8" // swarmsimulator.com
  erosson_com_zone_id = "9cd45b2dd8a01f74aa7e47e96ef0792c" // erosson.com
  erosson_us_zone_id = "3e80b1a30a4db8af6132a536d144472e" // erosson.us
  evanrosson_com_zone_id = "d647fab55890593346d839d4cd92679a" // evanrosson.com
  evanrosson_org_zone_id = "2e5e71f5a42a667ae3f651fcf08d2620" // evanrosson.org
  xmarkedgame_com_zone_id = "00f73e4217e15755e801a2830015dddd" // xmarkedgame.com
  war_swarms_com_zone_id = "111988a39faa077f7920ed8f8057e657" // war-swarms.com
  warswarm_com_zone_id = "cc9bb7d13f3634894f515d475933c922" // warswarm.com
  warswarms_com_zone_id = "9453bb5f2643566155fd5e0f562d4f42" // warswarms.com

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
  for_each = { for index, d in local.full_domains: d.full_domain => d }
  zone_id = each.value.zone_id
  type = "CNAME"
  name = each.value.sub == "" ? "@" : each.value.sub
  value = local.cname_value
  proxied = local.proxied
}