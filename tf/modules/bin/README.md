convenience scripts. symlink to these inside infra/ projects.

they use the directory's environment/stack and any shared authentication.

- `/infra/modules/bin/stack`: scripts for an environment-less application stack. setup: `cd /infra/<stack> && ln -s ../modules/bin/stack/tofu`
- `/infra/modules/bin/workspace`: scripts for one environment of a stack. uses Terraform workspaces. setup: `cd /infra/<stack>/<workspace> && ln -s ../../modules/bin/workspace/tofu`