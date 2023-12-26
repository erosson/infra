# Stateless `.tf` configuration

Things that *are* safe to delete and recreate, like website deployments or DNS entries.

You can fearlessly `tofu apply -destroy` this entire directory without making any backups - `tofu apply` will happily rebuild it all.

Prefer to put new resources in here whenever possible. Stateless resources are much easier to work with!