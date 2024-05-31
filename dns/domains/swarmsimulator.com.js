D("swarmsimulator.com", REG, DnsProvider(DNS),
	DefaultTTL(1),
	// terraform-managed
	IGNORE("@", "A"),
	IGNORE("@", "CNAME"),
	IGNORE("www"),
	// not terraform-managed
	MX("@", 10, "alt4.aspmx.l.google.com."),
	MX("@", 5, "alt2.aspmx.l.google.com."),
	MX("@", 10, "alt3.aspmx.l.google.com."),
	MX("@", 5, "alt1.aspmx.l.google.com."),
	MX("@", 1, "aspmx.l.google.com."),
	TXT("@", "google-site-verification=FanQhFnnlHrnKuMSMtc41zDWy4TemPHiqTsIPaNenh4")
)
