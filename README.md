**Reproducable infrastructure that can be deployed locally or globally.**

This repository contains a definition of infrastructure that can be trivially
reproduced on a commodity laptop, deployed to cloud providers or on-premesis
bare metal servers.

* https://learn.hashicorp.com
* https://katacoda.com/hashicorp


Design
----------
This section is going to reiterate common idioms that take inspiration from
Netflix, Facebook, and other such exemplars.

We use the latest Fedora release for all appliances to take advantage of BTRFS
and BPF improvements gained from a near-mainline kernel. Rather than creating
long-term strategies for handling software updates, our our goal is to deploy
relatively short-lived instances.

### Components
I'm not sure if it will stay this way, but I want to have as few components to
reason about as possible. The more kinds of "stuff" we have the more difficult
it will be to wrangle it in the future, should complexity creep in.

#### bootstrap
* https://github.com/ansible/ansible
* https://github.com/hashicorp/packer
* https://github.com/hashicorp/terraform
* https://github.com/hashicorp/vagrant

#### compute
* https://github.com/hashicorp/consul
* https://github.com/hashicorp/nomad
* https://github.com/hashicorp/vault

* https://github.com/hashicorp/boundary
* https://github.com/hashicorp/horizon
* https://github.com/hashicorp/waypoint

#### provisioner
* https://github.com/openstack/ironic

#### storage
* https://github.com/ceph/ceph

#### misc
* https://github.com/openstack/virtualbmc


Quickstart
----------
Despite the mono-repo approach, the initial setup isn't especially brutal. We
assume that you are using Fedora


1. Prepare the host system

    ```sh
    $ sudo dnf install -y dnf-plugins-core gcc libguestfs-tools-c libvirt \
        libvirt-devel libxml2-devel libxslt-devel make ruby-devel
    $ sudo dnf config-manager \
        --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    $ sudo dnf install -y packer terraform vagrant vault
    $ sudo ln -sf /usr/bin/packer{,.io}
    ```

    ```sh
    $ sudo firewall-cmd --permanent --zone=libvirt --add-service=nfs
    $ sudo firewall-cmd --permanent --zone=libvirt --add-service=rpc-bind
    $ sudo firewall-cmd --permanent --zone=libvirt --add-service=mountd
    $ sudo firewall-cmd --reload
    $ sudo systemctl restart nfs-server rpcbind.service
    $ sudo systemctl enable --now libvirtd
    ```

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
    (.venv) $ ansible-galaxy install -r ansible/requirements-ansible.yml
    (.venv) $ ansible-galaxy install -r compute/requirements-ansible.yml
    ```

4. Build and test an image

    ```sh
    (.venv) $ export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"
    (.venv) $ vagrant plugin install vagrant-libvirt
    ```

    ```sh
    (.venv) $ cd compute/
    (.venv) $ packer.io build compute.json
    (.venv) $ vagrant up
    ```
