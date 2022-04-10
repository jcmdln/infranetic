`Infranetic` is a brutalized portmanteau derived from the idea of "non-frenetic infrastructure"
that aims to simplify provider-agnostic deployments that can be reproduced locally and deployed
globally. This idea was inspired in part by the following:

* [Ansible and HashiCorp: Better Together (hashicorp.com)](
  https://www.hashicorp.com/resources/ansible-terraform-better-together)
* [Containers at Facebook by Lindsay Salisbury (youtube.com)](
  https://www.youtube.com/watch?v=_Qc9jBk18w8)
* [Mastering Chaos - A Netflix Guide to Microservices (youtube.com)](
  https://www.youtube.com/watch?v=CZ3wIuvmHeM)
* [BPF performance analysis at Netflix (youtube.com)](https://www.youtube.com/watch?v=16slh29iN1g)


Using
---
```sh
$ virtualenv .venv
$ source .venv/bin/activate
(.venv) $ pip install -r requirements/ansible.txt -r requirements/tox.txt
(.venv) $ ansible-galaxy install -r ./tools/requirements.yml
(.venv) $ ansible-playbook --ask-become-pass ./tools/setup-vagrant.yml
(.venv) $ newgrp libvirt
(.venv) $ tox -e build,deploy
```
