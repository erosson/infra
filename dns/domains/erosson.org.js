// imported with `dnscontrol get-zones --format=js cloudflare - erosson.org`
D("erosson.org", REG, DnsProvider(DNS),
    DefaultTTL(1),

    ///////////////////////////////////////////////////////
    // erosson.org has a lot of subdomains.
    // my most actively maintained and/or visited websites:
    ///////////////////////////////////////////////////////

    // https://www.erosson.org
    // https://gitlab.com/erosson/erosson-org - my personal website
    // the repo contains a bunch of terraform stuff. Most of it is DNS - no longer used, this replaces it. There's some s3 bucket config there too though!
    ALIAS("@", "erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
    CNAME("www", "www.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
    CNAME("piano", "piano.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),

    // https://mapwatch.erosson.org
    // https://github.com/mapwatch/mapwatch - path of exile map tracking
    CNAME("mapwatch", "mapwatch.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),

    // https://freecbt.erosson.org
    // https://github.com/erosson/freecbt - free cognitive behavioral therapy app
    CNAME("freecbt", "freecbt.netlify.app."),

    // https://gitlab.com/erosson/travel-erosson-org - my travel photos
    // originally hosted on tumblr at https://wheres.erosson.org, moved to git+s3 for long-term archival at https://travel.erosson.org
    CNAME("travel", "travel.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
    CNAME("wheres", "domains.tumblr.com."),

    A("finsat-qgis", "138.197.50.183"),

    ///////////////////////////////////////////////////////
    // stuff that isn't maintained, but still has some users:
    ///////////////////////////////////////////////////////

    // https://github.com/erosson/ch2plan - clicker heroes 2 skill tree planner. no longer maintained
    CNAME("ch2", "ch2.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),

    // https://github.com/erosson/wolcendb - datamined wolcen item and skill data
    // no longer maintained, I don't play wolcen anymore
    CNAME("wolcendb", "wolcendb.netlify.com."),
    CNAME("img-wolcendb", "img-wolcendb.erosson.org.s3.amazonaws.com.", CF_PROXY_ON),

    ///////////////////////////////////////////////////////
    // stuff managed by terraform:
    ///////////////////////////////////////////////////////
    IGNORE("test-tf"),
    IGNORE("cooking"),

    ///////////////////////////////////////////////////////
    // stuff that isn't widely used, and not maintained:
    ///////////////////////////////////////////////////////

    // https://github.com/erosson/elm-games
    CNAME("elmlab", "elm-games.pages.dev.", CF_PROXY_ON),

    // https://github.com/erosson/diff
    CNAME("diff", "erosson-diff.netlify.app."),

    // https://github.com/erosson/event-link
    CNAME("event", "erosson-event.netlify.app."),

    // https://github.com/erosson/freedbt
    CNAME("freedbt", "freedbt.pages.dev.", CF_PROXY_ON),

    // https://github.com/erosson/genealogy (private repo, but it's fine that the dns record's public)
    CNAME("genealogy", "cname.vercel-dns.com."),

    // https://github.com/erosson/keyboard-collector
    CNAME("keyboard-collector", "keyboard-collector.netlify.app."),

    // https://github.com/erosson/meditate
    CNAME("meditate", "gentle-hamster-b5f6bf.netlify.app."),

    // https://gitlab.com/erosson/piano-v2
    CNAME("piano-v2", "piano-v2.netlify.com."),

    // https://gitlab.com/erosson/random-items
    CNAME("random-items", "random-items-erosson-org.netlify.com."),

    // https://github.com/erosson/vegas-wordle
    CNAME("vegas-wordle", "vegas-wordle.netlify.app."),

    ///////////////////////////////////////////////////////
    // miscellaneous dns config, not visible to users:
    ///////////////////////////////////////////////////////

    // I'm not sure what this was for, but dnscontrol imported it and is upset about using it
    // TXT("freecbt", "google-site-verification=6c4MEAEhxCJK8sGQv1NnrI6IYK19B6286E1zZY5eeQg"),

    // https://keybase.io/erosson - keybase dns verification
    TXT("@", "keybase-site-verification=EncCl-wXPMH_QfyvaiYukWq9bUPykA8WJAKeKi2KOIM"),

    // erosson.org gmail configuration, I think
    CNAME("mail", "ghs.google.com."),
    MX("@", 1, "aspmx.l.google.com."),
    MX("@", 10, "aspmx2.googlemail.com."),
    MX("@", 5, "alt1.aspmx.l.google.com."),
    MX("@", 5, "alt2.aspmx.l.google.com."),
    MX("@", 10, "aspmx3.googlemail.com."),
    TXT("@", "v=spf1 include:_spf.google.com ~all"),
    TXT("google._domainkey", "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjyXZfzfqJBK7dUFBYZJmRBnHEVCNsIL7W/5oy0w/ETzEJAHLi3zEwtVzWJ4Ri67f6jyVwJrv0jj0Ul8LCgYx7I2jqJ9hPl9TLpU6pnwkdN4DPECbYvg1ryZmK4VeQkXceVb9iKZ9J6T7GGQq3Qfx+lKmMAh5M1dZ1a8ayaOIED9p8RuwOW/jNVuGkxVBuR0fbrYdg+TSx9xTb+feRbQ0iZqPlYERm08paKhn/3qsKJHtbeQMDnsfYc7fusNxFXTRXber1Pk5Sw27EFVJLPSZGkVAvsiRlA1vHLyqt2OH31Qm69lWjcP5XY/VhWdZRCOGO1h0etEiG+gRXWec0x29nwIDAQAB")
);
