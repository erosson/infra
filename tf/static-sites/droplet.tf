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
  # generate dns records.
  droplet_domains = [
    {sub="docker-ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="www", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="static-droplet", domain="erosson.org", zone_id=local.erosson_org_zone_id},
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
    {sub="www", domain="zealgame.com", zone_id=local.zealgame_com_zone_id},
    {sub="", domain="zealgame.com", zone_id=local.zealgame_com_zone_id},
    {sub="math2", domain="swarmsim.com", zone_id=local.swarmsim_com_zone_id},
    {sub="freecbt", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="cooking", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="vegas-wordle", domain="erosson.org", zone_id=local.erosson_org_zone_id},
  ]
}

###############################################################################
# New subdomains shouldn't need to modify anything after this point.
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

  full_droplet_domains = [ for d in local.droplet_domains: merge(d, {full_domain="${d.sub == "" ? "" : "${d.sub}."}${d.domain}"})]
}

resource "github_actions_secret" "main" {
  for_each = { for index, r in local.github_repositories: r => r }
  repository = each.value
  secret_name = "GH_TOKEN_INFRA_BUILD_DOCKER_IMAGE"
  plaintext_value = var.GITHUB_TOKEN_INFRA_BUILD_DOCKER_IMAGE
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 8192
}
resource "local_sensitive_file" "sshkey" {
  count = var.CI ? 0 : 1
  filename = ".ssh/id_rsa"
  content = tls_private_key.main.private_key_openssh
}
resource "local_sensitive_file" "sshkey_pub" {
  count = var.CI ? 0 : 1
  filename = ".ssh/id_rsa.pub"
  content = tls_private_key.main.public_key_openssh
}
resource "github_actions_secret" "STATIC_SITES_DEPLOY_PRIVATE_KEY" {
  repository = "infra"
  secret_name = "STATIC_SITES_DEPLOY_PRIVATE_KEY"
  plaintext_value = tls_private_key.main.private_key_openssh
}
resource "github_actions_secret" "STATIC_SITES_DEPLOY_PUBLIC_KEY" {
  repository = "infra"
  secret_name = "STATIC_SITES_DEPLOY_PUBLIC_KEY"
  plaintext_value = tls_private_key.main.public_key_openssh
}
# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key
resource "digitalocean_ssh_key" "main" {
  name = "tf: ssh/main"
  public_key = tls_private_key.main.public_key_openssh
}
data "cloudinit_config" "main" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yml"
    content_type = "text/cloud-config"
    content = file("${path.module}/server/cloud-config.yml")
  }
  part {
    # creates files. https://www.reddit.com/r/Terraform/comments/18cxum7/creating_files_on_remote_instance/
    filename     = "write-files.yml"
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          path = "/root/docker-compose.yml"
          permissions = "0644"
          owner = "root"
          content = file("${path.module}/server/docker-compose.yml")
        }
      ]
    })
  }
  part {
    # runs on startup. https://cloudinit.readthedocs.io/en/latest/explanation/format.html#mime-multi-part-archive
    filename     = "droplet-setup.sh"
    content_type = "text/x-shellscript"
    content = file("${path.module}/server/droplet-setup.sh")
  }
}

# The site is ready ~5 minutes after terraform finishes creating the machine.
# no healthcheck to check readiness or anything. Until then, the site will be down!
resource "digitalocean_droplet" "main" {
  image  = "docker-20-04"
  name   = "static-sites"
  # name   = "static-sites"
  region = "nyc1"
  # minimum size for docker image, but we don't actually need it
  # size   = "s-1vcpu-512mb-10gb"
  size   = "s-1vcpu-1gb"
  ipv6 = true
  ssh_keys = [digitalocean_ssh_key.main.fingerprint]
  user_data = data.cloudinit_config.main.rendered
  lifecycle {
    # this dramatically reduces downtime when recreating the droplet, but requires no volume_ids.
    create_before_destroy = true
  }
  provisioner "local-exec" {
    # https://stackoverflow.com/a/58759974
    command = "timeout 20m bash -c 'until curl --insecure --max-time 3 --fail --no-progress-meter http://${digitalocean_droplet.main.ipv4_address}/healthz ; do sleep 3; done'"
    interpreter = [ "/bin/bash", "-c" ]
  }
}

# TODO delete - not needed for self-signed certs
resource "digitalocean_volume" "main" {
  region = "nyc1"
  name = "static-sites"
  size = 5
  description = "Caddy's persistent data"
  initial_filesystem_type = "ext4"
  initial_filesystem_label = "static-sites"
}

## create a known_hosts file, so ssh/deploy work without a "host key verification failed" error
## ugh, screw this. I tried.
#resource "null_resource" "droplet_host_key" {
#  # triggers = {
#    # always_run = timestamp()
#  # }
#  depends_on = [ digitalocean_droplet.main ]
#  provisioner "local-exec" {
#    # https://hjr265.me/blog/generate-ssh-known-hosts-in-terraform/
#    command = "mkdir -p .ssh && ssh-keyscan static-droplet.erosson.org > .ssh/known_hosts_pristine && cp .ssh/known_hosts_pristine .ssh/known_hosts"
#    interpreter = [ "/bin/bash", "-c" ]
#  }
#}
#data "local_file" "droplet_host_key" {
#  # count = var.CI ? 0 : 1
#  count = 1
#  filename = "${path.module}/.ssh/known_hosts_pristine"
#  depends_on = [null_resource.droplet_host_key]
#}
#resource "github_actions_secret" "STATIC_SITES_DEPLOY_HOST_KEY" {
#  # count = var.CI ? 0 : 1
#  count = 1
#  repository = "infra"
#  secret_name = "STATIC_SITES_DEPLOY_HOST_KEY"
#  plaintext_value = data.local_file.droplet_host_key[0].content
#}

resource "digitalocean_reserved_ip" "main" {
  region = "nyc1"
}
resource "digitalocean_reserved_ip_assignment" "main" {
  lifecycle {
    # surprisingly, this seems to work! dramatically reduces downtime when recreating droplet.
    create_before_destroy = true
  }
  ip_address = digitalocean_reserved_ip.main.ip_address
  droplet_id = digitalocean_droplet.main.id
}

# For "proxied" to work, we must have cloudflare encryption-mode set to "full" or "full-strict".
# Without this, it redirects endlessly!
#
# This is set *by hand* in the ui, [domain] > ssl/tls: https://dash.cloudflare.com/fed1bc67ffb2f62c6deaa5c7f8f9eb93/erosson.org/ssl-tls
# Exceptions are managed with a config rule, *by hand*: https://dash.cloudflare.com/fed1bc67ffb2f62c6deaa5c7f8f9eb93/erosson.org/rules/configuration-rules/efea09ead5624fb1b854c03e08c8254d
# anything hosted at *.s3-website.* must be an exception, it doesn't support any sort of ssl.
# mapwatch, travel, piano, ch2
resource "cloudflare_record" "droplet" {
  # https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12 : "using for_each on a list of objects"
  for_each = { for index, d in local.full_droplet_domains: d.full_domain => d }
  zone_id = each.value.zone_id
  type = "A"
  name = each.value.sub == "" ? "@" : each.value.sub
  value = digitalocean_reserved_ip.main.ip_address
  # leave this unproxied, for ssh. can't ssh through a cloudflare proxy!
  proxied = each.value.sub != "static-droplet" ? "true" : "false"
}
output "ip_address" {
  value = digitalocean_reserved_ip.main.ip_address
}

# https://cloud.digitalocean.com/monitors/uptime/checks
resource "digitalocean_uptime_check" "www-erosson-org" {
  name    = "www-erosson-org"
  target  = "https://www.erosson.org/healthz"
  regions = ["us_east", "us_west", "eu_west", "se_asia"]
}
resource "digitalocean_uptime_check" "www-swarmsim-com" {
  name    = "www-swarmsim-com"
  target  = "https://www.swarmsim.com/"
  regions = ["us_east", "us_west", "eu_west", "se_asia"]
}