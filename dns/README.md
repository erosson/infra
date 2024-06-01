# [Evan's Infrastructure](..) > DNS

All DNS configuration, managed by [dnscontrol](https://dnscontrol.org/).

None of my subdomains are defined manually. Many are managed by Terraform, though - those are simply `IGNORE()`d here.

## Development

* Run `infisical login`.
* Change some code.
* Preview changes with `./bin/preview`. (CI runs this.)
* Apply changes with `./bin/push`.