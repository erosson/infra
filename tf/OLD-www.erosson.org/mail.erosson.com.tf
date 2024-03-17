resource "cloudflare_record" "mail_erosson_com" {
  domain = "erosson.com"
  name   = "mail"
  type   = "CNAME"
  value  = "ghs.google.com"
}

resource "cloudflare_record" "erosson_com_mx_1" {
  domain   = "erosson.com"
  name     = "erosson.com"
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  priority = "5"
}

resource "cloudflare_record" "erosson_com_mx_2" {
  domain   = "erosson.com"
  name     = "erosson.com"
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  priority = "5"
}

resource "cloudflare_record" "erosson_com_mx_3" {
  domain   = "erosson.com"
  name     = "erosson.com"
  type     = "MX"
  value    = "aspmx2.googlemail.com"
  priority = "10"
}

resource "cloudflare_record" "erosson_com_mx_4" {
  domain   = "erosson.com"
  name     = "erosson.com"
  type     = "MX"
  value    = "aspmx3.googlemail.com"
  priority = "10"
}

resource "cloudflare_record" "erosson_com_mx_5" {
  domain   = "erosson.com"
  name     = "erosson.com"
  type     = "MX"
  value    = "aspmx.l.google.com"
  priority = "1"
}

resource "cloudflare_record" "erosson_com_spf" {
  domain = "erosson.com"
  name   = "erosson.com"
  type   = "TXT"
  value  = "v=spf1 include:_spf.google.com ~all"
}

resource "cloudflare_record" "erosson_com_dkim" {
  domain = "erosson.com"
  name   = "google._domainkey"
  type   = "TXT"
  value  = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg2X95OJBAlBimKB8MNAlRuYoDUOw4KBA+O8PzhYsr/uCKU4wRvQu7xG2V1zbUnfjsFYhPSMSuBRdrNUfPn3PFLqyvUAfrbJeTatrSGaZGq/YUzpIGpL2t9qT1OwpD/Dl0wDsnLHCkC1SjFZAcfNebQHJhORiOhaoG3YvClliyuxUmeCkSJau4Trj38oD0XD8tMyOQWFPpvMwZlTjSPXoIw72T24YqxDn45JDWAhrYiVlcwAusw/38YHLqLjoVNzFxwunIAeqCCJmBMyZb81bE3wb6G5OrnLPSH01Z84VgXlGwtyGBRlu2X1baJoDlWPPH6gC7iivXiT3Tta7iAHs3wIDAQAB"
}
