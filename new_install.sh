#/bin/sh
# WARNING: this script nukes the given hard drive without any consideration.
[ -n "$1" ] && DISK="$1"
[ -n "$2" ] && PART="${DISK}$2" || PART="$DISK"
[ -n "$3" ] && SWAP_SIZE="$3" || SWAP_SIZE="32G"

[ -z "$DISK" ] && printf "Dunno what to do, bye." && exit 1
set -ex
printf "label: gpt\n,550M,U\n,,L\n" | sfdisk $DISK
#nix-shell -p btrfs-progs
mkfs.fat -F 32 ${PART}1

cryptsetup luksFormat --type=luks2  ${PART}2
ENC_PARTITION="encpar"
cryptsetup open ${PART}2 $ENC_PARTITION
VOLUME_GROUP_NAME="vogrona"
vgcreate $VOLUME_GROUP_NAME /dev/mapper/$ENC_PARTITION
LOGIC_VOLUME_NAME="lovona"
lvcreate --name $LOGIC_VOLUME_NAME -l +100%FREE $VOLUME_GROUP_NAME

mkfs.btrfs /dev/mapper/$VOLUME_GROUP_NAME-$LOGIC_VOLUME_NAME
mkdir -p /mnt
RP_NAME="/dev/mapper/$VOLUME_GROUP_NAME-$LOGIC_VOLUME_NAME"
mount $RP_NAME /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/swap
btrfs subvolume create /mnt/nix
umount /mnt

mount -o compress=zstd,subvol=root $RP_NAME /mnt
mkdir /mnt/{home,nix,swap}
mount -o compress=zstd,subvol=home $RP_NAME /mnt/home
mount -o compress=zstd,noatime,subvol=nix $RP_NAME /mnt/nix
mount -o compress=noatime,subvol=swap $RP_NAME /mnt/swap

mkdir /mnt/boot
mount ${PART}1 /mnt/boot

btrfs filesystem mkswapfile --size $SWAP_SIZE --uuid clear /mnt/swap/swapfile
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix new-system.nix

printf "Do the stuff in fs_skeleton, junge."
