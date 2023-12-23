D("swarmsimulator.com", REG, DnsProvider(DNS),
	DefaultTTL(1),
	A("@", "208.94.117.73", CF_PROXY_ON),
	CNAME("www", "swarmsim.nfshost.com.", CF_PROXY_ON),
	MX("@", 10, "alt4.aspmx.l.google.com."),
	MX("@", 5, "alt2.aspmx.l.google.com."),
	MX("@", 10, "alt3.aspmx.l.google.com."),
	MX("@", 5, "alt1.aspmx.l.google.com."),
	MX("@", 1, "aspmx.l.google.com."),
	TXT("@", "google-site-verification=FanQhFnnlHrnKuMSMtc41zDWy4TemPHiqTsIPaNenh4")
)
