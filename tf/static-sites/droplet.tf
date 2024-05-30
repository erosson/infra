###############################################################################
# Each new site must add a bit of config below.
# These should match the Caddyfile and Dockerfile in `/static-sites`, too.
###############################################################################
locals {
  # generate dns records and digitalocean-app domain entries
  droplet_domains = [
    {sub="docker-ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="ops", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="www", domain="erosson.org", zone_id=local.erosson_org_zone_id},
    {sub="static-droplet", domain="erosson.org", zone_id=local.erosson_org_zone_id},
  ]
}

###############################################################################
# New sites shouldn't need to modify anything after this point.
###############################################################################
locals {
  full_droplet_domains = [ for d in local.droplet_domains: merge(d, {full_domain="${d.sub == "" ? "" : "${d.sub}."}${d.domain}"})]
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
    content = file("${path.module}/cloud-config.yml")
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
          content = file("${path.module}/docker-compose.yml")
        }
      ]
    })
  }
  part {
    # runs on startup. https://cloudinit.readthedocs.io/en/latest/explanation/format.html#mime-multi-part-archive
    filename     = "droplet-setup.sh"
    content_type = "text/x-shellscript"
    content = file("${path.module}/droplet-setup.sh")
  }
}

# The site is ready ~5 minutes after terraform finishes creating the machine.
# no healthcheck to check readiness or anything. Until then, the site will be down!
resource "digitalocean_droplet" "main" {
  image  = "docker-20-04"
  # name   = "static-sites-${random_id.id.hex}"
  name   = "static-sites"
  region = "nyc1"
  # minimum size for docker image, but we don't actually need it
  # size   = "s-1vcpu-512mb-10gb"
  size   = "s-1vcpu-1gb"
  ipv6 = true
  ssh_keys = [digitalocean_ssh_key.main.fingerprint]
  user_data = data.cloudinit_config.main.rendered
  volume_ids = [ digitalocean_volume.main.id ]
  # NOPE, the persistent volume messes this up - it can only be mounted to one machine at a time.
  # For zero-downtime, we'll need to move SSL somewhere else to avoid any persistent data.
  # (And also configure a proper healthcheck somewhere, so we know when creation's really done.)
  # lifecycle {
  #   create_before_destroy = true
  # }
}
# resource "random_id" "id" {
# 	byte_length = 4
# }
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