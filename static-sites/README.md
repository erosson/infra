# [Evan's Infrastructure](..) > `static-sites` Docker image

[![Build Docker image for all static websites](https://github.com/erosson/infra/actions/workflows/build-docker-image.yml/badge.svg)](https://github.com/erosson/infra/actions/workflows/build-docker-image.yml)

Package all of my static sites as a single combined [Docker](https://www.docker.com/) image, running with a [Caddy webserver](https://caddyserver.com/).

## Development

    cd image
    docker compose up --build

then visit https://math2.swarmsim.com.localhost:2015 or https://cooking.erosson.org.localhost:2015, for example

### Adding a new site

100% infrastructure-as-code, in Terraform, Docker, and Caddy.

In the new site's git repository:

1. [create a standalone Docker image with a Caddy server for the new site.](https://github.com/mapwatch/mapwatch/blob/master/Dockerfile) You'll probably want `.dockerignore` and `docker-compose.yml` too.
2. [create a CI job to build the Docker image on git-push. When done, trigger the combined image's CI build.](https://github.com/mapwatch/mapwatch/blob/master/.github/workflows/build-docker-image.yml)

In the infrastructure repository:

1. [add the new site to combined Docker image](https://github.com/erosson/infra/commit/a376207d109b0d204196c2b051402e1ea3ce20e1)
2. [add DNS records for the new site](https://github.com/erosson/infra/commit/46160f7f3f0fc2c418a58dcf0cdeece980f8ad40)

This sounds like a lot - but it goes quickly, and IaC is easier to maintain than fiddling with some cloud provider's UI.

## Updating an existing site

Just `git push` to that site's repository. On push, the config above will run a complete deployment:

* build a new standalone Docker image for that site
* build a new combined Docker image with the updated site
* deploy the new combined image

## Webhost evaluation, tradeoffs, alternatives

There are many good ways to host static sites. A combined Docker image works well for me, but it has its issues too. There's no one right answer. 

*Why deploy one combined Docker image, instead of many standalone images?* Most Docker providers charge per container, and I have a lot of static sites. [Integration testing](./image/tests/) one combined image is easier - I only have to configure the tests once. It was easier to add new sites to one combined image, than it was to configure deployments for dozens of standalone images.

*Why not use a dedicated static site host, like Netlify or Cloudflare Pages?* I've used them before, they can be a good choice! They're often free, and probably have better uptime than my one-host Docker setup. But there's lots of vendor lock-in, I don't trust that they'll still work 10+ years from now, they all handle redirects poorly, and I don't mind $6/mo for a cheap Docker host.

Also, as of 06/2024, each provider has its own quirks and brokenness. Netlify's Terraform provider is completely broken, they're no good for IaC at all. Cloudflare Pages has much better IaC, but doesn't support monorepos (only one Pages site per git repo) and needs a bunch of configuration just to notify me when a deployment fails. It's possible to manage or work around all of these... but with a custom Docker setup, I don't have to.

*Why not use Amazon S3 or some other object store?* Another fine choice; I almost did this instead of Docker. Dirt cheap, great uptime, likely to still exist 10+ years from now, and lock-in's actually not bad these days. But configuring redirects is a huge pain, dev/local testing is harder, and configuring new projects is slightly more troublesome than Docker.