var domains = ["erosson.us", "evanrosson.com", "evanrosson.org", "xmarkedgame.com"]

for (var i in domains) {
    // ugh, no for-of - what ancient js interpreter is dnscontrol using
    var domain = domains[i]

    D(domain, REG, DnsProvider(DNS),
        IGNORE("@", "CNAME"),
        IGNORE("@", "A"),
        IGNORE("www")
    )
}
