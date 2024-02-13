# Infra

Evan's DNS and infrastructure configuration.

## DNS
DNS automatically applied on `git push` using [dnscontrol](https://dnscontrol.org/) and github actions.

## Opentofu (Terraform)
Configures cloudflare-pages static sites with corresponding github repos. It's new and poorly-tested; apply it manually.

Previously, I've tried putting `.tf` config for each app in that app's repository. Usually I prefer to keep everything related to an app in its repository. A single `infra` repository for all my infrastructure is a new experiment; I'm expecting several benefits: 
* Starting a new project is much easier. Old project config is right there for copying
* Auth for new projects is much easier. No need to create new credentials by hand
* Keeping infrastructure up to date is much easier. Just check the results of one CI job for diffs
