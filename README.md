Infra
=====

Evan's DNS and infrastructure configuration.

DNS automatically applied on `git push` using [dnscontrol](https://dnscontrol.org/) and github actions.

Opentofu (Terraform) configures cloudflare-pages static sites with corresponding github repos. It's new and poorly-tested; apply it manually. 