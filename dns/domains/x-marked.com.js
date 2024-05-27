D("x-marked.com", REG, DnsProvider(DNS),
	DefaultTTL(1),
	// https://gitlab.com/x-marked/x-marked.gitlab.io
	CNAME("www", "www.x-marked.com.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON),
	ALIAS("@", "www.x-marked.com.s3-website-us-east-1.amazonaws.com.", CF_PROXY_ON)
)
