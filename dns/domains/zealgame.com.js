D("zealgame.com", REG, DnsProvider(DNS),
	DefaultTTL(1),
	// https://github.com/erosson/zealgame.com
	IGNORE("www"),
	IGNORE("@", "CNAME"),
	MX("@", 5, "alt2.aspmx.l.google.com."),
	MX("@", 10, "aspmx2.googlemail.com."),
	MX("@", 1, "aspmx.l.google.com."),
	MX("@", 5, "alt1.aspmx.l.google.com."),
	MX("@", 10, "aspmx3.googlemail.com."),
	TXT("@", "google-site-verification=Xd99lUP1JnDZ3eYn08UAJBoelbqrOzb0a9PHvwaXbNk"),
	TXT("@", "v=spf1 -all")
)
