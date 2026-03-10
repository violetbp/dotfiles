# destructively formats a computer to be used with nix with full disk encryption
# decided not to have parted not promtp for user input 
# eh cobbled together i use qfpl.io/posts/installing-nixos/ as a base
 
set -euo pipefail
 
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi
 
# only for nvme
DISK="/dev/`lsblk --nvme --noheadings --output NAME`"
read -p "what will the hostname be:" host_name
 
# DISK="${1:-}"
# if [[ -z "$DISK" ]] || [[ ! -b "$DISK" ]]; then
#   echo "Usage: $0 /dev/sdX" >&2
#   exit 1
# fi
 
read -p "ALL DATA ON $DISK WILL BE DESTROYED. Continue? (type uppercase yes): " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Aborting." >&2
  exit 1
fi
 
echo "Creating GPT label and partitions"
parted -s --align optimal "$DISK" mklabel gpt
 
# ESP
parted -s --align optimal "$DISK" mkpart ESP fat32 1MiB "2GiB"
parted "$DISK" set 1 esp on
parted "$DISK" set 1 boot on
 
echo "recovery"
parted -s -a optimal "$DISK" mkpart recovery ext4 "2GiB" "15GiB"
parted "$DISK" set 2 boot on
 
echo "Creating lvm"
parted -s -a optimal "$DISK" mkpart lvm "15GiB" 100%
parted "$DISK" set 2 lvm on
 
EFI_PARTITION="${DISK}p1"
REC_PARTITION="${DISK}p2"
LVM_PARTITION="${DISK}p3"
 
mkfs.fat -F 32 -n ESP "$EFI_PARTITION"
mkfs.ext4 -L recovery "$REC_PARTITION"
 
echo "lvm time"
 
# -- You will be asked to enter your passphrase - DO NOT FORGET THIS
cryptsetup luksFormat $LVM_PARTITION
 
# -- Decrypt the encrypted partition and call it nixos-enc. The decrypted partition
# -- will get mounted at /dev/mapper/${host_name}-enc
cryptsetup luksOpen $LVM_PARTITION "${host_name}-enc"
 
# -- Create the LVM physical volume using ${host_name}-enc
pvcreate "/dev/mapper/${host_name}-enc" 
 
# -- Create a volume group that will contain our root and swap partitions
vgcreate "${host_name}-vg" "/dev/mapper/${host_name}-enc"
 
# -- Create a home partition that is ?? in size -- todo automate sizing.....
lvcreate -l 50%FREE -n home "${host_name}-vg"
 
# -- Create a logical volume for our root filesystem from all remaining free space.
# -- Volume is labeled "root"
lvcreate -l 100%FREE -n root "${host_name}-vg"	
 
# -- Create an ext4 filesystem for our partitions
mkfs.ext4 -L nixos_root "/dev/${host_name}-vg/root"
mkfs.ext4 -L nixos_home "/dev/${host_name}-vg/home"


mkdir -p /mnt/boot /mnt/home
mount "/dev/${host_name}-vg/root" /mnt
mount "/dev/${host_name}-vg/home" /mnt/home
mount $EFI_PARTITION /mnt/boot

mkdir -p /resc/boot
mount "/dev/${DISK}p2" /resc
mount $EFI_PARTITION /resc/boot

nixos-generate-config --root /mnt
nixos-generate-config --root /resc


edit the files

nixos-install --root /mnt
nixos-install --root /resc

