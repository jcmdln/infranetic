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


Building
----------

1. Prepare the host system

    ```sh
    $ sudo dnf config-manager \
        --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo \
        --exclude vagrant*
    $ sudo dnf install -y \
        libvirt-client packer python3-virtualenv vagrant-libvirt
    $ sudo unlink /usr/sbin/packer
    $ sudo gpasswd -a $USER libvirt
    $ newgrp libvirt
    ```

2. Add build dependencies

    ```sh
    $ virtualenv .venv
    $ source .venv/bin/activate
    (.venv) $ pip install -r requirements-python.txt
    (.venv) $ ansible-galaxy install -r requirements-ansible.yml
    ```

3. Build an image

    ```sh
    (.venv) $ packer build core.pkr.hcl

    # To rebuild after testing an image, run the following
    (.venv) $ vagrant destroy
    (.venv) $ vagrant box remove infranetic/core
    (.venv) $ virsh vol-list --pool default |
        awk '{print $1}' |
        grep infranetic |
        grep core |
        xargs virsh vol-delete --pool default --vol
    (.venv) $ packer build -force core.pkr.hcl
    ```

4. Test an image

    ```sh
    (.venv) $ vagrant box add \
        --name infranetic/core ./build/infranetic-core-amd64.box
    (.venv) $ vagrant up
    (.venv) $ vagrant ssh
    ```


Usage
----------
WIP

### Vault
Be sure to use `-tls-skip-verify` since we use a self-signed certificate. In
the future, this will be replaced by an option to generate a letsencrypt SSL if
you have a valid domain to associate.

	```sh
	$ vault status -tls-skip-verify
	```
