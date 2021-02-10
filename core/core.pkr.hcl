# core.pkr.hcl

variables {
    name             = "infranetic-core-amd64"
    os_arch          = "x86_64"
    os_mirror        = "http://mirrors.kernel.org/fedora/releases"
    os_version       = 33
    os_version_minor = 1.2
    userpass         = "infranetic"
    vagrant          = true

    ansible_settings = [
        "ANSIBLE_ANY_ERRORS_FATAL=True",
        "ANSIBLE_BECOME_METHOD='sudo'",
        "ANSIBLE_CALLBACK_WHITELIST=profile_roles,timer",
        "ANSIBLE_COMMAND_WARNINGS=False",
        "ANSIBLE_DIFF_ALWAYS=True",
        "ANSIBLE_FORKS=50",
        "ANSIBLE_GATHER_SUBSET=hardware,min,network,virtual",
        "ANSIBLE_GATHER_TIMEOUT=300",
        "ANSIBLE_GATHERING='smart'",
        "ANSIBLE_INJECT_FACT_VARS=True",
        "ANSIBLE_INVENTORY_ANY_UNPARSED_IS_FAILED=True",
        "ANSIBLE_NOCOWS=True",
        "ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=300",
        "ANSIBLE_PERSISTENT_CONNECT_TIMEOUT=300",
        "ANSIBLE_PIPELINING=True",
        "ANSIBLE_SFTP_BATCH_MODE=True",
        "ANSIBLE_SSH_ARGS='-C -o ControlMaster=auto -o ControlPersist=60s -o PreferredAuthentications=publickey'",
        "ANSIBLE_SSH_RETRIES=1",
        "ANSIBLE_TIMEOUT=300",
        "ANSIBLE_TRANSPORT='ssh'",
    ]
}

source "qemu" "core" {
    accelerator      = "kvm"
    boot_command     = [
        "e<down><down><end> ",
        "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg ",
        "<leftCtrlOn>x<leftCtrlOff>"
    ]
    boot_wait        = "10s"
    cpus             = 2
    disk_compression = true
    disk_interface   = "virtio-scsi"
    disk_size        = "20G"
    format           = "qcow2"
    headless         = true
    http_directory   = "./http"
    iso_checksum     = "file:${var.os_mirror}/${var.os_version}/Everything/${var.os_arch}/iso/Fedora-Everything-${var.os_version}-${var.os_version_minor}-${var.os_arch}-CHECKSUM"
    iso_url          = "${var.os_mirror}/${var.os_version}/Everything/${var.os_arch}/iso/Fedora-Everything-netinst-${var.os_arch}-${var.os_version}-${var.os_version_minor}.iso"
    memory           = 2048
    net_device       = "virtio-net"
    output_directory = "build/"
    qemuargs         = [["-bios", "/usr/share/edk2/ovmf/OVMF_CODE.fd"]]
    shutdown_command = "echo ${var.userpass} | sudo -S poweroff"
    ssh_agent_auth   = false
    ssh_password     = "${var.userpass}"
    ssh_timeout      = "15m"
    ssh_username     = "${var.userpass}"
    vm_name          = "${var.name}.qcow2"
}

build {
    sources = ["source.qemu.core"]

    provisioner "ansible" {
        ansible_env_vars       = "${var.ansible_settings}"
        ansible_ssh_extra_args = ["-o PubkeyAcceptedKeyTypes=+ssh-dss"]
        extra_arguments        = [
            "-e ansible_python_interpreter=auto_silent",
            "-e ansible_sudo_pass=${var.userpass}",
            "-e vagrant_target=${var.vagrant}"
        ]
        playbook_file          = "./ansible/site.yml"
    }

    post-processor "vagrant" {
        keep_input_artifact = true
        compression_level   = 9
        output              = "build/${var.name}.box"
        provider_override   = "libvirt"
    }
}
