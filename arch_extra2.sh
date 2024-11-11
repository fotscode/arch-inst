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

# create .config folder if it doesn't exist
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

packages_useful="rofi playerctl xbindkeys xvkbd nitrogen flameshot alsa-utils btop neofetch xorg-xset tree perl-image-exiftool pavucontrol onboard redshift xorg-xcursorgen ripgrep dunst fzf fd bat xdotool xorg-xwininfo exa pamixer unzip unrar man-db lxappearance xclip wmctrl gdu bc polkit-gnome colordiff picom"
packages_media="spotify-launcher thunderbird stremio noisetorch gimp qbittorrent sxiv yt-dlp inkscape libreoffice-fresh peek imagemagick scrot obsidian"
packages_flashing="balena-etcher woeusb"
packages_development="jdk-openjdk android-studio nvm libwnck3 python-pip python-black"
packages_fonts="ttf-roboto siji-git ttf-sourcecodepro-nerd ttf-iosevka-nerd ttf-hack-nerd ttf-font-awesome ttf-font-awesome-4 noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra"

echo "Useful packages: $packages_useful"
echo -en "Install useful packages? [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    paru -S $packages_useful
fi

echo "Media packages: $packages_media"
echo -en "Install media packages? [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    paru -S $packages_media
    xdg-mime default sxiv.desktop image/jpeg
    xdg-mime default sxiv.desktop image/png
    xdg-mime default sxiv.desktop image/gif
    xdg-mime default sxiv.desktop image/bmp
    xdg-mime default sxiv.desktop image/tiff
fi

echo "Flashing packages: $packages_flashing"
echo -en "Install flashing packages? [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    paru -S $packages_flashing
fi

echo "Development packages: $packages_development"
echo -en "Install development packages? [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    paru -S $packages_development
    /usr/share/nvm/init-nvm.sh
fi

echo "Fonts packages: $packages_fonts"
echo -en "Install fonts packages? [$(clrg "Y")/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    paru -S $packages_fonts
fi

if command -v nvm &> /dev/null; then
    echo -en "Install node? [$(clrg "Y")/n]: "
    read ok
    [[ $ok = "" ]] && ok="y"
    if [[ $ok =~ ^(y|Y).*$ ]]; then     
        nvm install node
    fi
fi
