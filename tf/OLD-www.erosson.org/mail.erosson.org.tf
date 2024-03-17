resource "cloudflare_record" "mail_erosson_org" {
  domain = "erosson.org"
  name   = "mail"
  type   = "CNAME"
  value  = "ghs.google.com"
}

resource "cloudflare_record" "erosson_org_mx_1" {
  domain   = "erosson.org"
  name     = "erosson.org"
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  priority = "5"
}

resource "cloudflare_record" "erosson_org_mx_2" {
  domain   = "erosson.org"
  name     = "erosson.org"
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  priority = "5"
}

resource "cloudflare_record" "erosson_org_mx_3" {
  domain   = "erosson.org"
  name     = "erosson.org"
  type     = "MX"
  value    = "aspmx2.googlemail.com"
  priority = "10"
}

resource "cloudflare_record" "erosson_org_mx_4" {
  domain   = "erosson.org"
  name     = "erosson.org"
  type     = "MX"
  value    = "aspmx3.googlemail.com"
  priority = "10"
}

resource "cloudflare_record" "erosson_org_mx_5" {
  domain   = "erosson.org"
  name     = "erosson.org"
  type     = "MX"
  value    = "aspmx.l.google.com"
  priority = "1"
}

resource "cloudflare_record" "erosson_org_spf" {
  domain = "erosson.org"
  name   = "erosson.org"
  type   = "TXT"
  value  = "v=spf1 include:_spf.google.com ~all"
}

resource "cloudflare_record" "erosson_org_dkim" {
  domain = "erosson.org"
  name   = "google._domainkey"
  type   = "TXT"
  value  = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjyXZfzfqJBK7dUFBYZJmRBnHEVCNsIL7W/5oy0w/ETzEJAHLi3zEwtVzWJ4Ri67f6jyVwJrv0jj0Ul8LCgYx7I2jqJ9hPl9TLpU6pnwkdN4DPECbYvg1ryZmK4VeQkXceVb9iKZ9J6T7GGQq3Qfx+lKmMAh5M1dZ1a8ayaOIED9p8RuwOW/jNVuGkxVBuR0fbrYdg+TSx9xTb+feRbQ0iZqPlYERm08paKhn/3qsKJHtbeQMDnsfYc7fusNxFXTRXber1Pk5Sw27EFVJLPSZGkVAvsiRlA1vHLyqt2OH31Qm69lWjcP5XY/VhWdZRCOGO1h0etEiG+gRXWec0x29nwIDAQAB"
}
