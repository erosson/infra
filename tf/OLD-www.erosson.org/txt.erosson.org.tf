resource "cloudflare_record" "keybase" {
  domain = "erosson.org"
  name   = "erosson.org"
  type   = "TXT"
  value  = "keybase-site-verification=EncCl-wXPMH_QfyvaiYukWq9bUPykA8WJAKeKi2KOIM"
}
