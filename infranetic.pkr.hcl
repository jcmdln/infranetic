# infranetic.pkr.hcl

variable "name" {
    type = string
    default = "infranetic-fedora"
}

variable "os_arch" {
    type = string
    default = "x86_64"
}

variable "os_mirror" {
    type = string
    default = "https://mirrors.kernel.org/fedora/releases"
}

variable "os_version" {
    type = number
    default = 34
}

variable "os_version_minor" {
    type = number
    default = 1.2
}

variable "userpass" {
    type = string
    default = "infranetic"
}

locals {
    imagename = "${var.name}-${var.os_version}-${var.os_version_minor}-${var.os_arch}"
    timestamp = formatdate("YYYYMMDD'T'hhmmssZZZZ", timestamp())
}

source "qemu" "infranetic" {
    accelerator = "kvm"
    boot_command = [
        "e<down><down><end> ",
        "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstart.cfg ",
        "<leftCtrlOn>x<leftCtrlOff>"
    ]
    boot_wait = "10s"
    cpus = 2
    disk_compression = true
    disk_interface = "virtio-scsi"
    disk_size = "20G"
    format = "qcow2"
    headless = true
    http_directory = "./"
    iso_checksum = "file:${var.os_mirror}/${var.os_version}/Everything/${var.os_arch}/iso/Fedora-Everything-${var.os_version}-${var.os_version_minor}-${var.os_arch}-CHECKSUM"
    iso_url = "${var.os_mirror}/${var.os_version}/Everything/${var.os_arch}/iso/Fedora-Everything-netinst-${var.os_arch}-${var.os_version}-${var.os_version_minor}.iso"
    memory = 2048
    net_device = "virtio-net"
    output_directory = "./build"
    qemuargs = [["-bios", "/usr/share/edk2/ovmf/OVMF_CODE.fd"]]
    shutdown_command = "echo ${var.userpass} | sudo -S poweroff"
    ssh_agent_auth = false
    ssh_password = "${var.userpass}"
    ssh_timeout = "15m"
    ssh_username = "${var.userpass}"
    vm_name = "${local.imagename}-${local.timestamp}.qcow2"
}

build {
    sources = ["source.qemu.infranetic"]

    provisioner "ansible" {
        ansible_env_vars = [
            "ANSIBLE_ANY_ERRORS_FATAL=True",
            "ANSIBLE_CALLBACK_WHITELIST=profile_roles,timer",
            "ANSIBLE_COMMAND_WARNINGS=False",
            "ANSIBLE_DIFF_ALWAYS=True",
            "ANSIBLE_GATHER_SUBSET=hardware,min,network,virtual",
            "ANSIBLE_INVENTORY_ANY_UNPARSED_IS_FAILED=True",
            "ANSIBLE_NOCOWS=True",
        ]
        ansible_ssh_extra_args = ["-o PubkeyAcceptedKeyTypes=+ssh-dss"]
        extra_arguments = [
            "-e ansible_python_interpreter=auto_silent",
            "-e ansible_sudo_pass=${var.userpass}",
        ]
        playbook_file = "./ansible/site-setup.yml"
    }

    provisioner "shell" {
        inline = ["rm -rf ~/~*"]
    }

    post-processor "vagrant" {
        compression_level = 9
        keep_input_artifact = true
        output = "./build/${local.imagename}-${local.timestamp}.box"
        provider_override = "libvirt"
    }
}
