# fedora-33.ks

reboot  # Reboot automatically when the installation is finished
skipx   # Skip configuring X
text    # Run installer in text mode

#
# Auth / Security
#

auth --enableshadow --passalgo="sha512"
rootpw --lock
selinux --enforcing
user --name="fedora" --password="fedora" --groups="wheel"

#
# Language / Locale
#

keyboard --vckeymap="us" --xlayouts="us"
lang en-US.UTF-8

#
# Network
#

firewall --enabled --service="ssh"
network --activate --bootproto="dhcp" --device="link" --ipv6="auto"
timezone America/New_York --utc

#
# Partitioning
#

ignoredisk --only-use="sda"
clearpart --all --drives="sda" --initlabel

part /boot/efi --fstype="efi"   --size="1024"
part /boot     --fstype="xfs"   --size="1024"
part btrfs.01  --fstype="btrfs" --size="1"    --ondisk="sda" --grow
part swap      --fstype="swap"  --size="4096"

btrfs none  --label="fedora" btrfs.01
btrfs /     --subvol --name="root" LABEL="fedora"
btrfs /home --subvol --name="home" LABEL="fedora"

#
# Packages / Services / Addons
#

url --url="https://mirrors.kernel.org/fedora/releases/33/Everything/x86_64/os/"

%packages
@core
btrfs-progs
%end

#
# Services / Addons
#

services --enabled="chronyd,sshd"

%addon com_redhat_kdump --disable --reserve-mb="128"
%end
