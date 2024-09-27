#!/usr/bin/env bash

# curl -sL https://files.wl.mort.is/backup-bootstrap.sh -o bootstrap.sh && sh bootstrap.sh
# https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f

devices=( /dev/sda /dev/sdb )

function clean_disk() {
    swapoff -a
    umount /mnt/boot/efi || true
    umount /mnt/boot2/efi || true
    umount /mnt || true
    lvremove -An OS -y || true
    vgremove OS -y || true
    pvremove /dev/mapper/cryptlvm -y || true
    cryptsetup close /dev/mapper/cryptlvm || true
    mdadm --stop /dev/md/os || true
    mdadm --stop /dev/md127 || true
    rm -rf /dev/md/os ./keyfile0.bin -rf || true

    for device in "${devices[@]}"; do
        echo "Clean disk: $device"
        mdadm --misc --zero-superblock $device || true
        mdadm --misc --zero-superblock "${device}1" || true
        mdadm --misc --zero-superblock "${device}2" || true
        wipefs -a $device
        dd if=/dev/zero of=$device bs=512 count=1 conv=notrunc
    done
}

# DESC: Partitions, formats and mounts disk
# ARGS: None
# OUTS: None
function partition_disk() {
    device=$1

    echo "Partition disk: $device"
    os_partition="${device}2"
    encrypt_partition=""
    swap_partition=""

    # set boot partition
    partition_commands="
n
1

+550M
ef00
n
2


fd00
w
y
"
    echo "$partition_commands" | gdisk $device
}

function setup_encrypt() {
    encrypt_partition=$os_partition
    os_partition=/dev/OS/root

    echo "Setup LUKS: $encrypt_partition"
    cryptsetup luksFormat -q --pbkdf pbkdf2 $encrypt_partition
    dd if=/dev/urandom of=./keyfile0.bin bs=512 count=4 iflag=fullblock
    cryptsetup -v luksAddKey $encrypt_partition keyfile0.bin

    echo "Open volume"
    cryptsetup luksOpen $encrypt_partition cryptlvm -d keyfile0.bin

    echo "Create LVM group"
    pvcreate /dev/mapper/cryptlvm
    vgcreate OS /dev/mapper/cryptlvm

    echo "Create LVM: /dev/OS/root"
    lvcreate -l 100%FREE OS -n root -An
}

# DESC: Partitions, formats and mounts disk
# ARGS: None
# OUTS: None
function partition_disks() {
    raid_members=()
    for device in "${devices[@]}"; do
        raid_members+=("${device}2")
        partition_disk $device
    done

    os_partition=/dev/md/os
    mdadm --create --verbose -R --level=10 --metadata=1.2 --chunk=512 --raid-devices="${#raid_members[@]}" --layout=f2 $os_partition "${raid_members[@]}"
    dd if=/dev/zero of=$os_partition bs=8M count=4

    setup_encrypt

    mkfs.ext4 $os_partition
    mount $os_partition /mnt
    for device in "${devices[@]}"; do
        mkfs.fat -F32 "${device}1"
    done
    mkdir /mnt/boot/efi /mnt/boot2/efi -p
    mount "${devices[0]}1" /mnt/boot/efi
    mount "${devices[1]}1" /mnt/boot2/efi
}

function remount() {
    encrypt_partition=/dev/md/nixos:os
    os_partition=/dev/OS/root

    cryptsetup luksOpen $encrypt_partition cryptlvm
    mount $os_partition /mnt
    mount "${devices[0]}1" /mnt/boot/efi
    mount "${devices[1]}1" /mnt/boot2/efi

    cp /mnt/etc/secrets/initrd ./keyfile0.bin
}

function install_nix() {
    mkdir -p /mnt/etc/secrets/initrd/
    dd if=/dev/urandom of=./keyfile1.bin bs=512 count=4 iflag=fullblock

    cp keyfile0.bin keyfile1.bin /mnt/etc/secrets/initrd
    chmod 000 /mnt/etc/secrets/initrd/keyfile*.bin
    nixos-generate-config --root /mnt

    curl -sL https://files.wl.mort.is/backup.nix -o /mnt/etc/nixos/configuration.nix
    nixos-install --no-root-password
}

clean_disk
partition_disks

# remount

# install_nix
