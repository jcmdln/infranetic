**Reproducible infrastructure that can be deployed locally or globally.**

This repository contains a definition of infrastructure that can be trivially
reproduced on commodity hardware, deployed to cloud providers or on-premesis
bare metal servers.

* https://learn.hashicorp.com
* https://katacoda.com/hashicorp


Design
----------
We use the latest Fedora release for all appliances to take advantage of BTRFS
and BPF improvements gained from a near-mainline kernel. Rather than creating
long-term strategies for handling software updates, our our goal is to deploy
relatively short-lived instances that share a common base and always make
services we deploy highly available.

### Components
To keep things simple, there are a handful of images that we refer to as
components that are definitions of a piece of the greater deployment.

#### common
This directory contains shared assets which are used by all other components
which includes Ansible tasks, kickstarts, and other such things.

#### compute
I want to test "HashiStack" and Kubernetes, starting with the former. Nomad
seems pretty simple (as in concise) and I've always wanted to dig into it. At
some point I'll have two compute components to evaluate each environment for
things like general simplicity and resource usage.

* https://github.com/hashicorp/consul
* https://github.com/hashicorp/nomad
* https://github.com/hashicorp/nomad-driver-podman
* https://github.com/containers/podman

Stuff I want to get around to incorporating:
* https://github.com/hashicorp/boundary
* https://github.com/hashicorp/horizon
* https://github.com/hashicorp/vault
* https://github.com/hashicorp/waypoint
* https://github.com/openstack/virtualbmc

#### provisioner
* https://github.com/digitalrebar/provision
* https://github.com/digitalrebar/provision-plugins

#### storage
* https://github.com/minio/minio


Quickstart
----------
Despite the mono-repo approach, the initial setup isn't especially brutal. We
assume that you are using Fedora and have some knowledge of the following:

* https://github.com/ansible/ansible
* https://github.com/hashicorp/packer
* https://github.com/hashicorp/terraform
* https://github.com/hashicorp/vagrant

1. Prepare the host system

	Install the base system package dependencies:

    ```sh
    $ sudo dnf install -y dnf-plugins-core gcc krb5-devel libguestfs-tools-c \
        libvirt libvirt-devel libxml2-devel libxslt-devel make ruby-devel \
        vagrant vagrant-libvirt
    ```

    firewalld should work out of the box, though you may need to make
    adjustments:

    ```sh
    $ sudo firewall-cmd --permanent --zone=libvirt --add-service=nfs
    $ sudo firewall-cmd --permanent --zone=libvirt --add-service=rpc-bind
    $ sudo firewall-cmd --permanent --zone=libvirt --add-service=mountd
    $ sudo firewall-cmd --reload
    $ sudo systemctl restart nfs-server rpcbind.service
    $ sudo systemctl enable --now libvirtd
    ```

	Optionally add your user to the 'libvirt' group so you won't have to build
	as root:

    ```sh
    $ sudo gpasswd -a ${USER} libvirt
    $ newgrp libvirt
    ```

2. Install Python dependencies

    ```sh
    $ virtualenv .venv
    $ source .venv/bin/activate
    (.venv) $ pip install -r requirements-python.yml
    ```

3. Install Ansible dependencies

    ```sh
    (.venv) $ ansible-galaxy install -r requirements-ansible.yml
    ```

4. Build and test an image

    ```sh
    (.venv) $ cd compute/
    (.venv) $ packer build compute.pkr.hcl
    (.venv) $ vagrant up
    ```
