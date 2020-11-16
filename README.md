**Reproducible infrastructure that can be deployed locally or globally.**

This repository contains a definition of infrastructure that can be trivially
reproduced on commodity hardware, deployed to cloud providers or on-premesis
bare metal servers.

We use the latest Fedora release for all appliances to take advantage of BTRFS
and BPF improvements gained from a near-mainline kernel. Our goal is to deploy
relatively short-lived instances that share a common base and require that all
services we deploy are highly available.

We assume that you are using Fedora and have some knowledge of the following
utilities, though it should be possible to replicate the setup on any Linux
distribution.

* https://github.com/ansible/ansible
* https://github.com/hashicorp/packer
* https://github.com/hashicorp/terraform
* https://github.com/hashicorp/vagrant


Usage
----------

1. Prepare the host system

    Install the base system package dependencies:

    ```sh
    $ sudo dnf install -y dnf-plugins-core gcc krb5-devel libguestfs-tools-c \
        libvirt libvirt-client libvirt-devel libxml2-devel libxslt-devel make \
        ruby-devel vagrant vagrant-libvirt
    ```

    Add your user to the 'libvirt' group so you won't have to build as root:

    ```sh
    $ sudo gpasswd -a $USER libvirt
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

4. Build an image

    ```sh
    (.venv) $ cd compute/
    (.venv) $ packer build compute.pkr.hcl
    ```

    If you are rebuilding an image, perform the following to remove any
    intermediary cached images, otherwise the vagrant box will be started with
    the old image and any changes you expect to be there won't be reflected:

    ```sh
    # Destroy the existing instance
    (.venv) $ vagrant destroy

    # Remove the box
    (.venv) $ vagrant box remove infranetic/compute

    # Remove all infranetic images (if not just one specific image)
    (.venv) $ virsh vol-list --pool default | grep infranetic |
        awk '{print $1}' | xargs virsh vol-delete --pool default --vol

    # Force a rebuild of the base image
    (.venv) $ packer build -force compute.pkr.hcl
    ```

5. Test an image

    ```sh
    # Add the image to Vagrant
    $ vagrant box add --name infranetic/compute ./build/compute-amd64-qemu-uefi.box

    # Bring the vagrant box up
    $ vagrant up

    # SSH into the running box
    $ vagrant ssh
    ```
