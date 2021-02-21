**Reproducible infrastructure that can be deployed locally or globally**

NOTE: THIS IS A WORK-IN-PROGRESS THAT IS LIKELY TO CHANGE RAPIDLY AND WITHOUT
WARNING. DO NOT ATTEMPT TO USE THIS REPOSITORY UNTIL THIS NOTICE HAS BEEN
REMOVED OR REPLACED WITH FRIENDLIER WORDING.

This repository is an attempt to formalize a working definition of reproducible
infrastructure that can be trivially replicated on commodity hardware. Our goal
is to deploy workload orchestrators locally using vagrant, to cloud providers
using Terraform, or on-premesis bare metal servers via PXE.


Usage
==========
We assume that you are using Fedora 33 or later and have some knowledge of the
following utilities, though it should be possible to replicate the setup on any
Linux distribution:

* https://github.com/ansible/ansible
* https://github.com/hashicorp/packer
* https://github.com/hashicorp/terraform
* https://github.com/hashicorp/vagrant

Preparing
----------
```sh
$ sudo dnf install -y ansible
$ ansible-playbook --ask-become-pass setup-localhost.yml
$ newgrp libvirt
```

Building
----------
### For local use with Vagrant
```sh
$ packer build -only="vagrant.*" infranetic.pkr.hcl
$ vagrant box add --name infranetic ./build/infranetic-amd64.box
$ vagrant up --no-parallel
$ vagrant ssh <instance>
```

To rebuild and use a new image, perform the following steps before running the
steps outlined above:

```sh
$ vagrant destroy -f
$ vagrant box remove infranetic
$ virsh vol-list --pool default | awk '/infranetic/ {print $1}' |
    xargs virsh vol-delete --pool default --vol
$ rm -rf build
```

### For use with Cloud Providers via Terraform
WIP

Deploying
----------
### Locally with Vagrant + Ansible
WIP

### In the cloud with Terraform + Ansible
WIP
