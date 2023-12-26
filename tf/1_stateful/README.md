# Stateful `.tf` configuration

Things that *are **not*** safe to delete and recreate, like Git repositories or databases.

Avoid `tofu apply -destroy`ing this directory. If you must do so, make a backup first. Destroying and recreating things in here will cause data loss!