Package all of my static sites as a single combined Docker image, configured by Caddy.

*Why?* Most Docker providers charge per container, and I have a lot of static sites. Static hosting providers are often free - but there's lots of vendor lock-in, and it's much more difficult to configure a new site with only infrastructure-as-code.

# Development

    docker compose up --build

then visit https://math2.swarmsim.com.localhost:2015 or https://cooking.erosson.org.localhost:2015, for example