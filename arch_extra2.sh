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


packages_useful = "rofi playerctl xbindkeys nitrogen flameshot alsa-utils btop neofetch xorg-xset tree perl-image-exiftool pavucontrol onboard redshift sleek xorg-xcursorgen ripgrep dunst fzf fd bat xdotool xorg-xwininfo exa pamixer unzip unrar man-db lxappearance xclip"
packages_media = "spotify-launcher thunderbird stremio noisetorch gimp qbittorrent sxiv rnote yt-dlp inkscape"
packages_flashing = "balena-etcher woeusb"
packages_development = "jdk-openjdk android-studio npm nodejs"
packages_fonts = "ttf-roboto siji-git ttf-sourcecodepro-nerd ttf-iosevka-nerd ttf-hack-nerd ttf-font-awesome ttf-font-awesome-4 noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra"

echo "Useful packages: $packages_useful"
echo -en "Install useful packages? ["$(clrg "Y")"/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    sudo paru -S $packages_useful
fi

echo "Media packages: $packages_media"
echo -en "Install media packages? ["$(clrg "Y")"/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    sudo paru -S $media_packages
fi

echo "Flashing packages: $packages_flashing"
echo -en "Install flashing packages? ["$(clrg "Y")"/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    sudo paru -S $packages_flashing
fi

echo "Development packages: $packages_development"
echo -en "Install development packages? ["$(clrg "Y")"/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    sudo paru -S $packages_development
fi

echo "Fonts packages: $packages_fonts"
echo -en "Install fonts packages? ["$(clrg "Y")"/n]: "
read ok
[[ $ok = "" ]] && ok="y"
if [[ $ok =~ ^(y|Y).*$ ]]; then     
    sudo paru -S $packages_fonts
fi
