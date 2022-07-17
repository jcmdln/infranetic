`Infranetic` is a brutalized portmanteau derived from the idea of "non-frenetic infrastructure" that aims to simplify provider-agnostic deployments that can be reproduced locally and deployed globally. This idea was inspired in part by the following:

-   [Ansible and HashiCorp: Better Together (hashicorp.com)](https://www.hashicorp.com/resources/ansible-terraform-better-together)
-   [Containers at Facebook by Lindsay Salisbury (youtube.com)](https://www.youtube.com/watch?v=_Qc9jBk18w8)
-   [Mastering Chaos - A Netflix Guide to Microservices (youtube.com)](https://www.youtube.com/watch?v=CZ3wIuvmHeM)
-   [BPF performance analysis at Netflix (youtube.com)](https://www.youtube.com/watch?v=16slh29iN1g)

## Using

### Prepare

```sh
# Setup and activate virtualenv
$ virtualenv .venv
$ source .venv/bin/activate

# Install Python dependencies
(.venv) $ pip install -r requirements.txt

# Install Ansible dependencies
(.venv) $ ansible-galaxy install -r requirements.yaml

# Setup localhost to run Vagrant
(.venv) $ ansible-playbook --ask-become-pass setup-vagrant.yaml
(.venv) $ newgrp libvirt
```

### Verify

```sh
(.venv) $ pip install -r requirements/tox.txt
(.venv) $ tox
```

### Deploy

```sh
# multi-node (Default)
(.venv) $ vagrant up
(.venv) $ ansible-playbook -i sample.inventory.yaml site.yaml

# single-node
(.venv) $ vagrant up mgmt1
(.venv) $ ansible-playbook -i sample.inventory.yaml -l mgmt1.infranetic site.yaml
```
