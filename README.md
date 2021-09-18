**Reproducible infrastructure that can be deployed locally or globally**

NOTE: THIS IS A WORK-IN-PROGRESS THAT IS LIKELY TO CHANGE RAPIDLY AND WITHOUT
WARNING. DO NOT ATTEMPT TO USE THIS REPOSITORY UNTIL THIS NOTICE HAS BEEN
REMOVED OR REPLACED WITH FRIENDLIER WORDING.

`Infranetic` is a brutalized portmanteau derived from the idea of "non-frenetic
infrastructure" that aims to provide reproducible deployments of "HashiStack"
that can be deployed locally or globally. This idea was inspired in part by the
following:

* [Ansible and HashiCorp: Better Together (hashicorp.com)](
  https://www.hashicorp.com/resources/ansible-terraform-better-together)
* [Containers at Facebook by Lindsay Salisbury (youtube.com)](
  https://www.youtube.com/watch?v=_Qc9jBk18w8)
* [Mastering Chaos - A Netflix Guide to Microservices (youtube.com)](
  https://www.youtube.com/watch?v=CZ3wIuvmHeM)
* [BPF performance analysis at Netflix (youtube.com)](
  https://www.youtube.com/watch?v=16slh29iN1g)


Usage
==========
Using `infranetic` is intended to highly economical in terms of hardware
requirements and prior knowledge. With a working understanding of Linux, it
_should_ be reasonable to have a single-instance local deployment in a few
minutes on commodity hardware.

Preparing
----------
```sh
$ virtualenv .venv
$ source .venv/bin/activate
(.venv) $ pip install -r requirements.txt
(.venv) $ ansible-galaxy install -r requirements.yml
(.venv) $ ansible-playbook --ask-become-pass setup-localhost.yml
(.venv) $ newgrp libvirt
```

Building & Deploying
----------
### Locally via Vagrant
```sh
(.venv) $ packer build fedora-34.pkr.hcl
(.venv) $ ansible-playbook setup-vagrant.yml
(.venv) $ vagrant up
(.venv) $ ansible-playbook -i sample.inventory.yml site.yml
```

### (WIP) In the Cloud via Terraform
```sh
(.venv) $ packer build -except "vagrant" fedora-34.pkr.hcl
```
