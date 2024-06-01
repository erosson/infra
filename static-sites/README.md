# [Evan's Infrastructure](..) > `static-sites` Docker image

TODO ci badge

Package all of my static sites as a single combined Docker image, configured by Caddy.

## Development

    cd image
    docker compose up --build

then visit https://math2.swarmsim.com.localhost:2015 or https://cooking.erosson.org.localhost:2015, for example

### Adding a new site

TODO

## Deployment

TODO

## Webhost evaluation, tradeoffs, alternatives

*Why one big docker image?* Most Docker providers charge per container, and I have a lot of static sites. Static hosting providers are often free - but there's lots of vendor lock-in, and it's much more difficult to configure a new site with only infrastructure-as-code.

TODO more details - copy tradeoffs from TODO file

* github pages/gitlab pages
* netlify
* cloudflare pages
* amazon s3
* caddy + docker image per site
* caddy + combined docker image (my choice)