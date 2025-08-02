// tailscale network
var TAILNET_Y40 = "100.119.33.50"
var TAILNET_ADDER = "100.64.162.105"
// home wifi network, outside tailscale/accessible to neighbors
var LOCALNET = "192.168.86.248"
// imported with `dnscontrol get-zones --format=js cloudflare - erosson.org`
D("erosson.org", REG, DnsProvider(DNS),
    DefaultTTL(1),

    ///////////////////////////////////////////////////////
    // erosson.org has a lot of subdomains.
    // my most actively maintained and/or visited websites:
    // ...are all terraformed now :)
    ///////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////
    // stuff that isn't maintained, but still has some users:
    ///////////////////////////////////////////////////////

    // https://github.com/erosson/ch2plan - clicker heroes 2 skill tree planner. no longer maintained
    CNAME("ch2", "ch2.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
    CNAME("piano", "piano.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),


    // https://github.com/erosson/wolcendb - datamined wolcen item and skill data
    // no longer maintained, I don't play wolcen anymore
    CNAME("wolcendb", "wolcendb.netlify.com."),
    CNAME("img-wolcendb", "img-wolcendb.erosson.org.s3.amazonaws.com.", CF_PROXY_ON),

    ///////////////////////////////////////////////////////
    // stuff managed by terraform:
    ///////////////////////////////////////////////////////
    IGNORE("test-tf"),
    IGNORE("cooking"),
    // https://github.com/erosson/freecbt - free cognitive behavioral therapy app
    IGNORE("freecbt"),
    // https://github.com/erosson/vegas-wordle
    IGNORE("vegas-wordle"),
    // https://gitlab.com/erosson/erosson-org
    IGNORE("cf-www"),
    // https://mapwatch.erosson.org
    // https://github.com/mapwatch/mapwatch - path of exile map tracking
    // CNAME("mapwatch", "mapwatch.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
    IGNORE("mapwatch"),

    IGNORE("@", "ALIAS"),
    IGNORE("@", "CNAME"),
    IGNORE("@", "A"),
    IGNORE("docker-ops"),
    IGNORE("ops"),
    IGNORE("docker-cooking"),
    IGNORE("docker-vegas-wordle"),
    IGNORE("docker-freecbt"),
    IGNORE("docker"),
    IGNORE("docker-www"),
    IGNORE("www"),
    IGNORE("static-droplet"),
    IGNORE("docker-genealogy"),

    ///////////////////////////////////////////////////////
    // stuff that isn't widely used, and not maintained:
    ///////////////////////////////////////////////////////

    // my private home network. it's fine to expose these domains/ips, they're inside tailscale
    A("home", TAILNET_Y40),
    A("home.home", TAILNET_Y40),  // for tailscale search domains. https://home.home.erosson.org/ -> https://home/
    A("default.home", TAILNET_Y40),
    A("status.home", TAILNET_Y40),
    A("kuma.home", TAILNET_Y40),
    A("gatus.home", TAILNET_Y40),
    A("proxmox.home", TAILNET_Y40),

    A("jellyfin.home", TAILNET_Y40),
    A("nextcloud.home", TAILNET_Y40),
    A("syncthing.home", TAILNET_Y40),
    A("watchtower.home", TAILNET_Y40),
    A("x.home", TAILNET_Y40),
    A("yt.home", TAILNET_Y40),
    A("adguard.home", TAILNET_Y40),
    A("grist.home", TAILNET_Y40),

    A("adder", TAILNET_ADDER),
    A("adder.adder", TAILNET_ADDER),
    A("default.adder", TAILNET_ADDER),
    A("status.adder", TAILNET_ADDER),
    A("x.adder", TAILNET_ADDER),
    A("syncthing.adder", TAILNET_ADDER),
    A("adguard.adder", TAILNET_ADDER),

    A("adder.local", LOCALNET),
    A("local", LOCALNET),

    // https://github.com/erosson/diff
    // CNAME("diff", "erosson-diff.netlify.app."),

    // https://github.com/erosson/event-link
    // CNAME("event", "erosson-event.netlify.app."),

    // https://github.com/erosson/freedbt
    // CNAME("freedbt", "freedbt.pages.dev.", CF_PROXY_ON),

    // https://github.com/erosson/genealogy (private repo, but it's fine that the dns record's public)
    IGNORE("genealogy"),

    // https://github.com/erosson/keyboard-collector
    // CNAME("keyboard-collector", "keyboard-collector.netlify.app."),

    // https://gitlab.com/erosson/piano-v2
    // CNAME("piano-v2", "piano-v2.netlify.com."),

    // https://gitlab.com/erosson/random-items
    // CNAME("random-items", "random-items-erosson-org.netlify.com."),

    // https://gitlab.com/erosson/travel-erosson-org - my travel photos
    // originally hosted on tumblr at https://wheres.erosson.org, moved to git+s3 for long-term archival at https://travel.erosson.org
    CNAME("travel", "travel.erosson.org.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
    CNAME("wheres", "domains.tumblr.com."),

    // A("finsat-qgis", "138.197.50.183"),

    ///////////////////////////////////////////////////////
    // miscellaneous dns config, not visible to users:
    ///////////////////////////////////////////////////////

    // I'm not sure what this was for, but dnscontrol imported it and is upset about using it
    // TXT("freecbt", "google-site-verification=6c4MEAEhxCJK8sGQv1NnrI6IYK19B6286E1zZY5eeQg"),

    // https://keybase.io/erosson - keybase dns verification
    TXT("@", "keybase-site-verification=EncCl-wXPMH_QfyvaiYukWq9bUPykA8WJAKeKi2KOIM"),

    // google search console site verification
    TXT("@", "google-site-verification=DnQIaVLGOb-OuuWglt5iz_BEkhZkh1t4qsVUZkdz4sQ"),

    // bluesky
    TXT("_atproto", "did=did:plc:4txjaouzrleil6ul3x4nmicx"),

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
