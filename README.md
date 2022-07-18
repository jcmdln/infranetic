`Infranetic` is a brutalized portmanteau derived from the idea of "non-frenetic infrastructure" that aims to simplify provider-agnostic deployments that can be reproduced locally and deployed globally. This idea was inspired in part by the following:

- [Ansible and HashiCorp: Better Together (hashicorp.com)][ansible-hashicorp]
- [Containers at Facebook by Lindsay Salisbury (youtube.com)][containers-facebook]
- [Mastering Chaos - A Netflix Guide to Microservices (youtube.com)][mastering-chaos]
- [BPF performance analysis at Netflix (youtube.com)][bpf-at-netflix]

[ansible-hashicorp]: https://www.hashicorp.com/resources/ansible-terraform-better-together
[containers-facebook]: https://www.youtube.com/watch?v=_Qc9jBk18w8
[mastering-chaos]: https://www.youtube.com/watch?v=CZ3wIuvmHeM
[bpf-at-netflix]: https://www.youtube.com/watch?v=16slh29iN1g

## Using

### Prepare

```sh
# Setup and activate virtualenv
virtualenv .venv
source .venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Install Ansible dependencies
ansible-galaxy install -r requirements.yml

# Setup localhost to run Vagrant
ansible-playbook --ask-become-pass setup-vagrant.yml
newgrp libvirt
```

### Verify

```sh
pip install -r requirements/tox.txt
tox
```

### Deploy

```sh
# multi-node (Default)
vagrant up
ansible-playbook -i sample.inventory.yml site.yml

# single-node
vagrant up mgmt1
ansible-playbook -i sample.inventory.yml -l mgmt1.infranetic site.yml
```
