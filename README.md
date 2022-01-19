**Reproducible infrastructure that can be deployed locally or globally**

NOTE: THIS IS A WORK-IN-PROGRESS THAT IS LIKELY TO CHANGE RAPIDLY AND WITHOUT
WARNING. DO NOT ATTEMPT TO USE THIS REPOSITORY UNTIL THIS NOTICE HAS BEEN
REMOVED OR REPLACED WITH FRIENDLIER WORDING.

`Infranetic` is a brutalized portmanteau derived from the idea of "non-frenetic
infrastructure" that aims to provide provider-agnostic deployments that can be
reproduced locally and deployed globally. This idea was inspired in part by the
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
$ sudo dnf install ansible
$ ansible-galaxy collection install -r requirements.yml
$ ansible-playbook --ask-become-pass setup-vagrant.yml
$ newgrp libvirt
```

Building
----------
### Locally via Vagrant
```sh
$ packer build -var="os_version=35" fedora.pkr.hcl
$ vagrant box add build/35/x86_64/manifest.json
```

Deploying
----------
### Locally with Vagrant
```
$ vagrant up
$ ansible-playbook -i sample.inventory.yml site.yml
```
