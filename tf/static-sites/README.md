TODO docs, why

To add a new site:
* Add the new repository and its domains to `main.tf`. Apply, but don't yet commit.
* Build a docker image of the new site. Copy Dockerfile, docker-compose.yml, .dockerignore from another site, and tweak as needed.
* Add a CI job to build and push the docker image on git-push. Copy `.github/workflows/build-docker-image.yml` from another site, and tweak as needed.
* Add the new package to the combined docker image by editing `/static-sites/Dockerfile` and `/static-sites/Caddyfile`.
* Commit and push changes to this repository