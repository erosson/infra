# tumblr fails at https without this
resource "cloudflare_page_rule" "wheres_erosson_org" {
  zone   = "erosson.org"
  target = "wheres.erosson.org/*"

  actions = {
    automatic_https_rewrites = "on"
  }
}

resource "cloudflare_record" "wheres_erosson_org" {
  domain  = "erosson.org"
  name    = "wheres"
  type    = "CNAME"
  value   = "domains.tumblr.com"
  proxied = false
}
