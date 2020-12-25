# core.pkr.hcl

variable "name" {
    type    = string
    default = "infranetic-core-amd64"
}

variable "os_arch" {
    type    = string
    default = "x86_64"
}

variable "os_mirror" {
    type    = string
    default = "http://mirrors.kernel.org/fedora/releases"
}

variable "os_version" {
    type    = string
    default = "33"
}

variable "os_version_minor" {
    type    = string
    default = "1.2"
}

variable "userpass" {
    type    = string
    default = "infranetic"
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
        ansible_ssh_extra_args = ["-o PubkeyAcceptedKeyTypes=+ssh-dss"]
        extra_arguments        = [
            "-e ansible_python_interpreter=auto_silent",
            "-e ansible_sudo_pass=${var.userpass}",
            "-e vagrant_target=True"
        ]
        playbook_file          = "./ansible/common-ansible/site.yml"
    }

    provisioner "ansible" {
        ansible_ssh_extra_args = ["-o PubkeyAcceptedKeyTypes=+ssh-dss"]
        extra_arguments        = [
            "-e ansible_python_interpreter=auto_silent",
            "-e ansible_sudo_pass=${var.userpass}"
        ]
        playbook_file          = "./ansible/hashisuite-ansible/site.yml"
    }

    post-processor "vagrant" {
        keep_input_artifact = true
        compression_level   = 9
        output              = "build/${var.name}.box"
        provider_override   = "libvirt"
    }
}
