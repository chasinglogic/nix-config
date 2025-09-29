#!/usr/bin/env bash

set -e
set -x

DISK=${DISK:-"/dev/nvme0n1"}

parted --script "$DISK" -- mklabel gpt
parted --script "$DISK" -- mkpart root btrfs 512MB 100%
parted --script "$DISK" -- mkpart ESP fat32 1MB 512MB
parted --script "$DISK" -- set 2 esp on

BTRFS_PART="${DISK}p1"
BOOT_PART="${DISK}p2"

mkfs.fat -F 32 -n boot "$BOOT_PART"
mkfs.btrfs -f "$BTRFS_PART"

mount "$BTRFS_PART" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
umount /mnt

mount -o noatime,compress=zstd,subvol=@ "$BTRFS_PART" /mnt
mkdir -p /mnt/home /mnt/nix /mnt/boot /mnt/var/log
mount -o noatime,compress=zstd,subvol=@home "$BTRFS_PART" /mnt/home
mount -o noatime,compress=zstd,subvol=@nix "$BTRFS_PART" /mnt/nix
mount -o noatime,compress=zstd,subvol=@log "$BTRFS_PART" /mnt/var/log
mount "$BOOT_PART" /mnt/boot

nixos-generate-config --root /mnt
# For whatever reason nixos-generate-config doesn't correctly add the mount options we
# used above so this puts them in.
sed -i 's/"subvol=@.*"/\0 "compress=zstd" "noatime"/' /mnt/etc/nixos/hardware-configuration.nix

cat >/mnt/etc/nixos/initial-ssh-setup.nix <<EOF
{...}:
{
    services.openssh = {
        enable = true;
        settings = {
            PermitRootLogin = "yes";
        };
    };
}
EOF

sed -i 's%./hardware-configuration.nix%\0\n      ./initial-ssh-setup.nix%' /mnt/etc/nixos/configuration.nix

nixos-install
