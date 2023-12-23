D("war-swarms.com", REG, DnsProvider(DNS),
	DefaultTTL(1),
	A("*", "185.162.9.62"),
	A("@", "172.67.133.183", CF_PROXY_ON),
	A("@", "104.21.5.184", CF_PROXY_ON),
	A("www", "172.67.133.183", CF_PROXY_ON),
	A("www", "104.21.5.184", CF_PROXY_ON),
	AAAA("@", "2606:4700:3033::ac43:85b7", CF_PROXY_ON),
	AAAA("@", "2606:4700:3031::6815:5b8", CF_PROXY_ON),
	AAAA("www", "2606:4700:3031::6815:5b8", CF_PROXY_ON),
	AAAA("www", "2606:4700:3033::ac43:85b7", CF_PROXY_ON)
)
