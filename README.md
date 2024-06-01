# Evan's Infrastructure

[![drift-check](https://github.com/erosson/infra/actions/workflows/drift-check.yml/badge.svg)](https://github.com/erosson/infra/actions/workflows/drift-check.yml)
[![Build Docker image for all static websites](https://github.com/erosson/infra/actions/workflows/build-docker-image.yml/badge.svg)](https://github.com/erosson/infra/actions/workflows/build-docker-image.yml)

Evan's web [infrastructure as code](https://aws.amazon.com/what-is/iac/).

This repository sets up DNS, web hosting, monitoring, and end-to-end tests. Whenever possible, I write code for these things here. When that's not possible, I document my manual steps here.

## Contents

Each directory below has its own documentation:

* [`/tf`](/tf): configure all cloud hardware and software with [Opentofu](https://opentofu.org/) ([Terraform](https://www.terraform.io/)). Most code lives here.
* [`/dns`](/dns): configure some domains and subdomains for my sites with [dnscontrol](https://dnscontrol.org/).
* [`/static-sites`](/static-sites): combines all my static websites into a single [Docker](https://www.docker.com/) image, for easier hosting.
* [`/tests`](/tests): simple read-only automated testing of my production infrastructure. Think "does this redirect work" and "is the correct website running at this address", not "was this obscure application bug fixed".

Secrets, like API keys and authentication tokens, are stored with [Infisical](https://infisical.com/).

## Continuous integration and deployment

I use Github Actions for CI.

If the [`drift-check`](https://github.com/erosson/infra/actions/workflows/drift-check.yml) job is green, all code in this repository is up-to-date and matches what's actually running. If it's red, something's out of sync - code doesn't match what's live.

This repository's CI generally does not *deploy* infrastructure changes - instead I deploy most changes myself, while I'm writing them. I'm a big fan of continuous deployment for *application* code, but *infrastructure* code is often finicky and hard to test locally. Running changes myself before git-push has worked much better for me. (This tradeoff might end differently if more than one person worked on this infrastructure and we had to worry about credentials, or if I were better at getting `.tf` code right on the first try.)

One big exception to the previous paragraph is the `static-sites` Docker image. It's deployed after every git-push, in this repository *or in any child site's repository*. See the [`/static-sites` readme](/static-sites).

## Why one `infra` repository?

*Wouldn't it make sense to put each app's infrastructure in its git repo, alongside the application code, instead of blending it all together in one repo?*

I've tried that! Didn't go well. A single `infra` repository has worked much, much better for me.

* Keeping infrastructure consistent across all my projects is easier.
    * It's much easier to see how each project is hosted when it's all defined in one place.
        * I have many static sites, and want to host most of them the same way. Before centralizing infra, I had at least 5 different web hosts.
        * Experimenting with new hosting is still possible, but centralizing makes it easier to remember where I'm running those experiments.
    * When I'm changing infrastructure, I'm most often thinking about *my infrastructure in general*, not about *one specific app*.
* Starting new projects is easier.
    * This repository has already set up auth and secrets. Without centralized infra, we have to bootstrap these by hand - tedious.
    * Old project config is right there for copying. Often, we can even loop through similar projects.

*What about working with other teams?*

That changes the tradeoffs. The projects here are owned solely by me; different ownership complicates things. It wouldn't make sense to add projects for other clients/teams/companies to this repository. I usually create one `infra` repository per client/team/company, or package it alongside their application code.

*What about private projects?*

You caught me, I have [one more closed-source infrastructure repo](https://github.com/erosson/infra-private).