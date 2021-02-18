# Adding a new role
```sh
$ molecule init role <role_name> --driver-name podman
$ cd <role_name>/molecule/default
$ ln -sf ../../../../requirements.yml
```
