**Reproducible infrastructure that can be deployed locally or globally**

NOTE: THIS IS A WORK-IN-PROGRESS THAT IS LIKELY TO CHANGE RAPIDLY AND WITHOUT
WARNING. DO NOT ATTEMPT TO USE THIS REPOSITORY UNTIL THIS NOTICE HAS BEEN
REMOVED OR REPLACED WITH FRIENDLIER WORDING.

This repository contains a definition of infrastructure that can be trivially
reproduced on commodity hardware, deployed to cloud providers or on-premesis
bare metal servers.

We use the latest Fedora release for all appliances to take advantage of BTRFS
and BPF improvements gained from a near-mainline kernel. Our goal is to deploy
relatively short-lived instances that share a common base and require that all
services we deploy are highly available.


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
$ ansible-galaxy collection install -r ansible/requirements.yml
$ ansible-playbook --ask-become-pass ansible/setup.yml
$ newgrp libvirt
```

Building
----------
```sh
$ packer build infranetic.pkr.hcl
```

To rebuild and use a new image, perform the following steps:

```sh
$ vagrant destroy -f
$ vagrant box remove infranetic
$ virsh vol-list --pool default | awk '/infranetic/ {print $1}' |
    xargs virsh vol-delete --pool default --vol
$ packer build -force infranetic.pkr.hcl
```

Running
----------
### Locally with Vagrant
```sh
$ vagrant box add --name infranetic ./build/infranetic-amd64.box
$ vagrant up
$ vagrant ssh
```
