#!/bin/bash
# Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

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
echo "Defaults in green"

echo -en "Username [leave empty if non existing]: "
read ok
user_created=1
[[ $ok = "" ]] && user_created=0
user_name=$ok


echo -en "Install base-devel, devtools, xrandr? [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    sudo pacman -S base-devel devtools xorg-xrandr
    base_devel=1
else
    base_devel=0
fi

echo -en "Download paru [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ && $base_devel -eq 1 ]]; then
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    paru=1
else
    paru=0
fi

echo -en "Download drivers amd/nvidia [$(clrg "0")/1]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    sudo pacman -S amd-ucode mesa mesa-vdpau libva-mesa-driver vulkan-radeon xf86-video-amdgpu xf86-video-ati
else 
    sudo pacman -S nvidia nvidia-utils nvidia-settings
fi

echo -en "Download WM/Desktop i3/gnome [$(clrg "0")/1]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    sudo pacman -S i3-wm i3-gaps i3status i3lock i3blocks 
else 
    sudo pacman -S gnome gnome-extra
fi

echo -en "Download polybar [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then
    sudo pacman -S polybar
fi

echo -en "Download gdm/lightdm [$(clrg "0")/1]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    sudo pacman -S gdm
    systemctl enable gdm
    echo "$(clrr "WARNING:") edit /etc/gdm/custom.conf and uncomment \"WaylandEnable=false\" if using x11"
else 
    sudo pacman -S lightdm lightdm-gtk-greeter
    systemctl enable lightdm
fi

echo -en "Download brave/google-chrome/firefox [$(clrg "0")/1/2]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    paru -S brave-bin
elif [[ $ok =~ ^1$ ]]; then
    paru -S google-chrome
else
    paru -S firefox
fi

echo -en "Download kitty/alacritty/konsole [$(clrg "0")/1/2]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    paru -S kitty
elif [[ $ok =~ ^1$ ]]; then
    paru -S alacritty
else
    paru -S konsole
fi

echo -en "Download zsh [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then
    sudo pacman -S zsh
    [[ $user_created -eq 1 ]] && echo "Executing $(clrg "chsh -s /bin/zsh $user_name")" && chsh -s /bin/zsh $user_name
fi

echo -en "Download neovim/vscode [$(clrg "0")/1]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    paru -S neovim
elif [[ $ok =~ ^1$ ]]; then
    paru -S visual-studio-code-bin
fi

echo -en "Download sioyek/zathura [$(clrg "0")/1]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    paru -S sioyek
elif [[ $ok =~ ^1$ ]]; then
    paru -S zathura
fi

echo -en "Download discord/teams/zoom [$(clrg "0")/1/2]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    paru -S discord
elif [[ $ok =~ ^1$ ]]; then
    paru -S teams
else
    paru -S zoom
fi

echo -en "Download mpv/vlc [$(clrg "0")/1]: "
read ok
[[ $ok = "" ]] && ok="0"
if [[ $ok =~ ^0$ ]]; then     
    paru -S mpv
elif [[ $ok =~ ^1$ ]]; then
    paru -S vlc
fi

echo "$(clrr "WARNING:") execute visudo and uncomment \"%wheel ALL=(ALL:ALL) ALL\" almost at the end of the file"
