Core
==========

We use the latest Fedora release for all appliances to take advantage of BTRFS
and BPF improvements gained from a near-mainline kernel. Our goal is to deploy
relatively short-lived instances that share a common base and require that all
services we deploy are highly available.

We assume that you are using Fedora and have some knowledge of the following
utilities, though it should be possible to replicate the setup on any Linux
distribution:

* https://github.com/ansible/ansible
* https://github.com/hashicorp/packer
* https://github.com/hashicorp/terraform
* https://github.com/hashicorp/vagrant


Usage
----------

1. Prepare the host system

    Add HashiCorp repo:

    ```sh
    $ sudo dnf config-manager \
        --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo \
        --exclude vagrant*
    ```

    Add system dependencies:

    ```sh
    $ sudo dnf install -y dnf-plugins-core gcc krb5-devel libguestfs-tools-c \
        libvirt libvirt-client libvirt-devel libxml2-devel libxslt-devel make \
        packer ruby-devel vagrant vagrant-libvirt
    ```

    (Optional) Add user to 'libvirt' group:

    ```sh
    $ sudo gpasswd -a $USER libvirt
    $ newgrp libvirt
    ```

2. Add build dependencies

    Setup virtualenv:

    ```sh
    $ virtualenv .venv
    $ source .venv/bin/activate
    ```

    Install Python dependencies:
    ```sh
    (.venv) $ pip install -r requirements-python.yml
    ```

    Install Ansible dependencies:

    ```sh
    (.venv) $ ansible-galaxy install -r requirements-ansible.yml
    ```

3. Build an image

    Perform your first build:

    ```sh
    $ cd compute/
    $ packer.io build compute.pkr.hcl
    ```

    If you are rebuilding an image, perform the following steps to remove any
    intermediary cached images, otherwise the vagrant box will be started with
    the old image and any changes you expect to be there won't be reflected:

    ```sh
    # Destroy the existing instance
    $ vagrant destroy

    # Remove the box from Vagrant
    $ vagrant box remove infranetic/compute

    # Remove the image from libvirt
    $ virsh vol-list --pool default | awk '{print $1}' | grep infranetic |
        grep compute | xargs virsh vol-delete --pool default --vol

    # Force a rebuild of the base image
    $ packer.io build -force compute.pkr.hcl
    ```

4. Test an image

    ```sh
    # Add the image to Vagrant
    $ vagrant box add --name infranetic/core ./build/infranetic-core-amd64.box

    # Bring the vagrant box up
    $ vagrant up

    # SSH into the running box
    $ vagrant ssh
    ```
