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
resource "digitalocean_droplet" "main" {
  image  = "docker-20-04"
  name   = "static-sites"
  region = "nyc1"
  # minimum size for docker image, but we don't actually need it
  # size   = "s-1vcpu-512mb-10gb"
  size   = "s-1vcpu-1gb"
  ipv6 = true
  ssh_keys = [digitalocean_ssh_key.main.fingerprint]
  user_data = file("./droplet-setup.sh")
  volume_ids = [ digitalocean_volume.main.id ]
  depends_on = [ digitalocean_volume.main ]
}
resource "digitalocean_volume" "main" {
  region = "nyc1"
  name = "static-sites"
  size = 5
  description = "Caddy's persistent data"
  initial_filesystem_type = "ext4"
  initial_filesystem_label = "static-sites"
}
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