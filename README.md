**Reproducable infrastructure that can be deployed locally or globally.**

This repository contains a definition of infrastructure that can be trivially
reproduced on a commodity laptop, deployed to cloud providers or on-premesis
bare metal servers.

* https://learn.hashicorp.com
* https://katacoda.com/hashicorp


Components
=========
* https://github.com/hashicorp/boundary
* https://github.com/hashicorp/consul
* https://github.com/hashicorp/horizon
* https://github.com/hashicorp/nomad
* https://github.com/hashicorp/packer
* https://github.com/hashicorp/terraform
* https://github.com/hashicorp/vagrant
* https://github.com/hashicorp/vault
* https://github.com/hashicorp/waypoint


Design
=========
This section is going to reiterate common idioms that take inspiration from
Netflix, Facebook, and other such exemplars.

We use the latest supported Fedora releases for all appliances. Because of the
excellent support for bpf/btrfs due to tracking newer kernels, we may deploy
relatively short-lived instances. Fedora supports the two latest stable
releases and has no automated kernel livepatch facilities, so we need to be
sure that we can rapidly replace an entire host without fear.


Quickstart
=========
Despite the mono-repo approach, the initial setup isn't especially brutal. We
assume that you are using Fedora


1. Install system package dependencies

    ```sh
    $ sudo dnf install -y dnf-plugins-core
    $ sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    $ sudo dnf -y install packer terraform vagrant vault
    $ sudo ln -sf /usr/bin/packer{,.io}
    ```

2. Install Python and Ansible dependencies

    ```sh
    $ virtualenv ansible/.venv
    $ source ansible/.venv/bin/activate
    (.venv) $ pip install -r ansible/requirements-python.yml
    (.venv) $ ansible-galaxy collection install -r ansible/requirements-ansible.yml
    (.venv) $ ansible-galaxy role install -r ansible/requirements-ansible.yml
    ```

3. Build and test an image

    ```sh
    $ cd fedora/33/
    $ packer.io build fedora-33.json
    $ vagrant up
    ```
