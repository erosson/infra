// currently a simple alias to erosson.org
D("erosson.com", REG, DnsProvider(DNS),
    DefaultTTL(1),
    IGNORE("@", "CNAME"),
    IGNORE("www", "CNAME"),
    CNAME("mail", "ghs.google.com."),
    MX("@", 5, "alt1.aspmx.l.google.com."),
    MX("@", 1, "aspmx.l.google.com."),
    MX("@", 5, "alt2.aspmx.l.google.com."),
    MX("@", 10, "aspmx3.googlemail.com."),
    MX("@", 10, "aspmx2.googlemail.com."),
    TXT("@", "v=spf1 include:_spf.google.com ~all"),
    TXT("@", "google-site-verification=VYOE2N9GULZ5Bjq5I4UJRC6CeQIN30fBDBBXLU7Bxfg"),
    TXT("google._domainkey", "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg2X95OJBAlBimKB8MNAlRuYoDUOw4KBA+O8PzhYsr/uCKU4wRvQu7xG2V1zbUnfjsFYhPSMSuBRdrNUfPn3PFLqyvUAfrbJeTatrSGaZGq/YUzpIGpL2t9qT1OwpD/Dl0wDsnLHCkC1SjFZAcfNebQHJhORiOhaoG3YvClliyuxUmeCkSJau4Trj38oD0XD8tMyOQWFPpvMwZlTjSPXoIw72T24YqxDn45JDWAhrYiVlcwAusw/38YHLqLjoVNzFxwunIAeqCCJmBMyZb81bE3wb6G5OrnLPSH01Z84VgXlGwtyGBRlu2X1baJoDlWPPH6gC7iivXiT3Tta7iAHs3wIDAQAB")
)