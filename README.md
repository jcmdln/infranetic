**Reproducible infrastructure that can be deployed locally or globally**

NOTE: THIS IS A WORK-IN-PROGRESS THAT IS LIKELY TO CHANGE RAPIDLY AND WITHOUT
WARNING. DO NOT ATTEMPT TO USE THIS REPOSITORY UNTIL THIS NOTICE HAS BEEN
REMOVED OR REPLACED WITH FRIENDLIER WORDING.

`Infranetic` is a brutalized portmanteau derived from "non-frenetic
infrastructure" with a goal of evaluating reproducible deployments of
"HashiStack" and Kubernetes for comparison. This idea was inspired in part by
the following:

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
We assume that you are using Fedora 33 or later and have some knowledge of the
following utilities, though with some effort it should be possible to replicate
the setup on any Linux distribution.

Preparing
----------
```sh
$ sudo dnf install -y ansible
$ ansible-playbook --ask-become-pass setup-localhost.yml
$ newgrp libvirt
```

Building & Deploying
----------
### Locally via Vagrant
```sh
$ ansible-playbook setup-vagrant.yml
$ vagrant up
```

### (WIP) In the Cloud via Terraform
```sh
$ packer build -except="vagrant" infranetic.pkr.hcl
```
