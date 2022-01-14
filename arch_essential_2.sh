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

# Creating a swapfile
echo -en "Size for $(clrg "/swapfile"). Default: $(clrg "4GB"): "
read swap_size
if ! [[ $swap_size =~ ^[0-9]+[MG]B$ ]]; then
        swap_size="4GB"
fi
echo $swap_size
fallocate -l "$swap_size" /swapfile
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab.bak > /dev/null
cat /etc/fstab.bak
echo -en "Everything ok? [Y/n]: "
read ok
[[ $ok =~ ^n+$ ]] && exit $E_NCON
mv /etc/fstab.bak /etc/fstab

# Setting timezone
ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc

# Setting language locale
echo -en "Choose an UTF-8 locale. Default: $(clrg "en_US"): "
read locale
[[ $locale = "" ]] && locale="en_US"
loc=$(grep "${locale}.UTF-8" /etc/locale.gen | tail -1 | awk -F "#" '{print $2}')
awk -v loc="#${loc}" -F"#" '$0~loc {print $2} {print}' /etc/locale.gen > /etc/locale.gen.bak
awk -F "#" '! /^#/ {print}' /etc/locale.gen.bak
echo -en "Everything ok? [Y/n]: "
read ok
[[ $ok =~ ^n+$ ]] && exit $E_NCON
mv /etc/locale.gen.bak /etc/locale.gen
locale-gen
echo "LANG=$locale.UTF-8" > /etc/locale.conf.bak
cat /etc/locale.conf.bak
echo -en "Everything ok? [Y/n]: "
read ok
[[ $ok =~ ^n+$ ]] && exit $E_NCON
mv /etc/locale.conf.bak /etc/locale.conf

# Setting hostname
echo -en "Insert your personal hostname. Default: $(clrg "arch"): "
read host_name
echo "$host_name" > /etc/hostname
echo -e "\n127.0.0.1 localhost\n::1 localhost\n127.0.1.1 $host_name" >> /etc/hosts

# Setting password
passwd

# Setting bootloader
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable NetworkManager
systemctl enable NetworkManager

# Last steps!
echo -en "$(clrg "Last steps!")"
echo "type $(clrg "exit")"
echo "then $(clrg "umount -a")"
echo "and after that $(clrg "reboot")"
