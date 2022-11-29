#!/bin/bash
# Void Linux Post Install Setup Script.



### --- TOP --- ###

## Script Logging
LOG_LOCATION=/home/$USER/void-deploy
exec > >(tee -i $LOG_LOCATION/installation_log)
exec 2>&1
echo "Log Location will be: [ $LOG_LOCATION ]"



### --- FUNCTION DEFINITIONS --- ###

## Define Enlightenment Installation Packages Function
Enlightenment () {
sudo xbps-install -S --yes base-devel qtbrowser enlightenment nano git axel curl wget libcurl-devel xorg libXft-devel libX11-devel libXinerama-devel libXt-devel xtools xdg-desktop-portal pulse audio pulseaudio-devel htop btop vlc terminus-font nerd-fonts-ttf gnupg zip p7zip python3-pip xz binutils ffmpeg bridge-utils cryptsetup github-cli dmidecode libdrm-32bit libgcc-32bit libopencv-python3 libstdc++-32bit libvirt lvm2network-manager-applet openbsd-netcat python-devel python3-devel python3-distutils xarchiver xauth xorg-input-drivers xorg-minimal xorg-video-drivers xsel void-docs-browse rust cargo SDL-devel SDL-devel-32bit SDL_image-devel SDL_image SDL_ttf ImageMagick dhclient exiftool glu gimp fuse-overlayfs libglvnd-32bit moc python3-argh python3-ConfigArgParse python3-distlib python-distutils-extra wally-cli tree setxkbmap task xbindkeys idle-python3 xdg-utils lightdm
}

## Define XFCE4 Installation Packages Function
XFCE4 () {
sudo xbps-install -S --yes base-devel qtbrowser xfce4-terminal thunar nano git axel curl wget libcurl-devel xorg libXft-devel libX11-devel libXinerama-devel libXt-devel xtools xdg-desktop-portal pulse audio pulseaudio-devel htop btop vlc terminus-font nerd-fonts-ttf gnupg zip p7zip python3-pip xz binutils ffmpeg bridge-utils cryptsetup github-cli dmidecode libdrm-32bit libgcc-32bit libopencv-python3 libstdc++-32bit libvirt lvm2network-manager-applet openbsd-netcat python-devel python3-devel python3-distutils xarchiver xauth xorg-input-drivers xorg-minimal xorg-video-drivers xsel void-docs-browse rust cargo SDL-devel SDL-devel-32bit SDL_image-devel SDL_image SDL_ttf ImageMagick dhclient exiftool glu gimp fuse-overlayfs libglvnd-32bit moc python3-argh python3-ConfigArgParse python3-distlib python-distutils-extra wally-cli tree setxkbmap task xbindkeys idle-python3 xdg-utils greetd tuigreet
}


## Define ZSH Installation and Configuration Function
zsh-install () {
sudo xbps-install -S --yes zsh
sudo chsh -s /bin/zsh $USER
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cd
cp ~/void-deploy/configs/zsh/.zshrc ~/.zshrc
cp ~/void-deploy/configs/zsh/.p10k.zsh ~/.p10k.zsh
}


### --- CORE INSTALLATION --- ###

## System Update
sudo xbps-install -Syy
sudo xbps-install -u xbps
sudo xbps-install -Syu

## Create Needed Folders
sudo mkdir /usr/share/xsessions
mkdir ~/.config

## Enable Non-Free/Multilib Repos
sudo xbps-install -S --yes void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
sudo xbps-install -Syy


## User Chooses 'Minimal' or 'Full' Installation
PS3='Installation type: '
options=("Enlightenment" "XFCE4" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "Enlightenment")
      echo "Enlightenment package installation initialized."
      Enlightenment
      echo "Enlightenment package installation completed."
      break
      ;;
    "XFCE4")
      echo "XFCE4 package installation initialized."
      XFCE4
      echo "XFCE4 package installation completed."
      break
      ;;
    "Quit")
      exit 0
      ;;
    *) echo "Invalid option: $REPLY";;
  esac
done

## User Chooses Their Shell
PS3='Decide a shell: '
options=("Zsh" "Fish" "Bash" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "Zsh")
      echo "Zsh selected."
      zsh-install
      echo "Zsh installation completed."
      break
      ;;
    "Bash")
      echo "Bash selected."
      echo "Bash installation completed."
      break
      ;;
    "Quit")
      exit 0
      ;;
    *) echo "Invalid option: $REPLY";;
  esac
done



### --- CONFIGURATION --- ###



### --- REBOOT --- ###



sudo reboot
