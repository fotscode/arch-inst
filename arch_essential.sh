# Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Exit codes, start with E_
E_SUCC=0 # success
E_DISK=1 # invalid disk
E_NCON=2 # negative confirmation


# Functions
clrg(){
	echo -e "${GREEN}$1${NC}"	
}
clrr(){
	echo -e "${RED}$1${NC}"	
}
err(){
	echo -e "$(clrr "ERROR:")"
}

# Pacman keyrings
pacman-key --init
pacman-key --populate archlinux

# Disks
echo -e "-----------------   $(clrg "UEFI DISK SETUP")   -----------------"
sudo fdisk -l | grep "Disk [/m]"
echo -en "Select disk. e.g: $(clrg "/dev/sdx"): "
read disk
if ! [[ $disk =~ ^/dev/[hvs]d[a-zA-Z]$ ]]; then 
	echo "$(err) Invalid disk" && exit $E_DISK
fi
echo -en "Size for $(clrg "/boot"). Default: $(clrg "512M"): "
read boot_size
echo -en "Size for $(clrg "/"). Default: $(clrg "30G"): "
read root_size
[[ $boot_size = "" ]] && boot_size="512M"
[[ $root_size = "" ]] && root_size="30G"

# Check number of type Linux Root/Home
types=$(printf "g\nn\n\n\n+$boot_size\nt\nL\n" | fdisk "$disk" 2>&1)
t_root=$(echo "$types" | grep "Linux root (x86-64)" | awk '{print $1}')
t_home=$(echo "$types" | grep "Linux home" | awk '{print $1}')

echo -e "-----------------$(clrg "CHECK PARTITION TABLE")-----------------"
printf "g\nn\n\n\n+$boot_size\nt\n1\nn\n\n\n+$root_size\nt\n\n$t_root\nn\n\n\n\nt\n\n$t_home\np\n" | fdisk "$disk" 2> /dev/null | head -n 41 | tail -n 12
echo -e "^^^^^^^^^^^^^^^^^$(clrg "CHECK PARTITION TABLE")^^^^^^^^^^^^^^^^^"
echo -en "Everything ok? [Y/n]: "
read ok
[[ $ok =~ ^n+$ ]] && exit $E_NCON
printf "g\nn\n\n\n+$boot_size\nt\n1\nn\n\n\n+$root_size\nt\n\n$t_root\nn\n\n\n\nt\n\n$t_home\nw\n" | fdisk "$disk" &> /dev/null
echo -e "Succesfully wrote $(clrg "$disk")"

# Formatting partitions
echo -e "Formatted partition ${disk}1 with vfat"
mkfs.vfat "${disk}1" &> /dev/null 
echo -e "Formatted partition ${disk}2 with ext4"
mkfs.ext4 "${disk}2" &> /dev/null
echo -e "Formatted partition ${disk}3 with ext4"
mkfs.ext4 "${disk}3" &> /dev/null

# Mounting partitions
mount "${disk}2" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount "${disk}1" /mnt/boot
mount "${disk}3" /mnt/home

# Installling base packages
pacstrap /mnt base base-devel linux linux-headers linux-firmware vim dhcpcd networkmanager

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# curl second script
curl https://gitlab.com/fotscode/arch-inst/-/raw/main/arch_essential_2.sh > /mnt/arch_essential_2.sh
chmod +x /mnt/arch_essential_2.sh

# finishing
echo "Continue by executing second script"
echo "$(clrg "./arch_essential_2.sh")"

# arch-chroot
arch-chroot /mnt

exit $E_SUCC
