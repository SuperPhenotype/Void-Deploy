#!/bin/bash
# Void Linux with DWM and SOWM Deployment (my flavour)



### --- TOP --- ###



## Script Logging
LOG_LOCATION=/home/$USER/void-deploy
exec > >(tee -i $LOG_LOCATION/installation_log)
exec 2>&1
echo "Log Location will be: [ $LOG_LOCATION ]"



### --- FUNCTION DEFINITIONS --- ###



## Define Minimal Installation Packages Function
minimal-install () {
sudo xbps-install -S --yes base-devel xorg libXft-devel libX11-devel libXinerama-devel libXt-devel xdg-utils libcurl-devel dbus-devel dbus-glib-devel xcb-imdkit xcb-proto xcb-util xcb-util-cursor xcb-util-errors xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm xcb-util-xrm libxcb-devel xcb-util-keysyms-devel xcb-util-wm-devel xcb-util-xrm-devel curl wget xtools ranger xdg-desktop-portal pulseaudio pulseaudio-devel ntp micro pcmanfm firefox nodejs htop btop mpv feh exa neofetch vim alacritty picom fzf moc gnupg gtk+3-devel p7zip mercurial lemonbar zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps zip xz binutils ffmpeg ufetch w3m w3m-img xsel wally-cli setxkbmap xbindkeys task ntfs-3g greetd tuigreet
}


## Define Full Installation Packages Function
full-install () {
sudo xbps-install -S --yes base-devel xorg libXft-devel libX11-devel libXinerama-devel libXt-devel libcurl-devel dbus-devel dbus-glib-devel curl wget xtools ranger xdg-desktop-portal pulseaudio pulseaudio-devel ntp micro pcmanfm firefox nodejs htop btop mpv feh terminus-font nerd-fonts-ttf exa neofetch vim alacritty picom fff fzf moc gnupg gtk+3-devel p7zip mercurial python3-pip zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps zip xz binutils ffmpeg bluez mdadm bridge-utils cryptsetup element-desktop lemonbar dejavu-fonts-ttf dmidecode font-misc-misc github-cli glxinfo gvfs-afc gvfs-mtp gvfs-smb libcurl-devel libdrm-32bit libgcc-32bit libopencv-python3 libstdc++-32bit libvirt lvm2 mesa-dri-32bit mesa-vaapi mesa-vdpau mesa-vulkan-radeon mono ncdu network-manager-applet noto-fonts-cjk noto-fonts-emoji ntfs-3g olm olm-python3 openbsd-netcat pfetch python-devel python3-devel python3-distutils-extra qemu steam udisks2 virt-manager virt-viewer vkd3d vkd3d-devel w3m w3m-img weechat weechat-python wmctrl xarchiver xauth xorg-input-drivers xorg-minimal xorg-video-drivers xsel void-docs-browse rust cargo ufetch rxvt-unicode SDL SDL-32bit SDL-devel SDL-devel-32bit SDL_image-devel SDL_image SDL_ttf ImageMagick dhclient exiftool glu gimp fuse-overlayfs libglvnd-32bit moc python3-argh python3-ConfigArgParse python3-distlib python-distutils-extra wally-cli tree setxkbmap task xbindkeys idle-python3 xdg-utils greetd tuigreet
}


## DWM Installation Function
dwm-install () {
mkdir suckless
cd suckless
git clone https://github.com/sademik/dwm
git clone git://git.suckless.org/st
git clone git://git.suckless.org/dmenu
git clone https://github.com/sademik/slstatus
sudo make clean install -C /home/$USER/suckless/dwm
sudo make clean install -C /home/$USER/suckless/st
sudo make clean install -C /home/$USER/suckless/dmenu
sudo make clean install -C /home/$USER/suckless/slstatus
cd
cp void-deploy/configs/xinitrc/.xinitrc_dwm .xinitrc_dwm
sudo cp void-deploy/configs/xsessions/dwm.desktop /usr/share/xsessions/dwm.desktop
cp void-deploy/scripts/dwm.sh ~/dwm.sh
sudo chmod +x ~/dwm.sh
}


## SOWM Installation Function
sowm-install () {
git clone https://github.com/sademik/sowm
git clone git://git.suckless.org/dmenu
cd sowm
git apply patches/110.patch
cd
sudo make clean install -C /home/$USER/sowm
sudo make clean install -C /home/$USER/dmenu
cp void-deploy/configs/xinitrc/.xinitrc_sowm .xinitrc_sowm
sudo cp void-deploy/configs/xsessions/sowm.desktop /usr/share/xsessions/sowm.desktop
cp void-deploy/scripts/sowm.sh ~/sowm.sh
sudo chmod +x ~/sowm.sh
}


## 2BWM Installation Function
2bwm-install () {
git clone https://github.com/sademik/2bwm
git clone git://git.suckless.org/dmenu
sudo make clean install -C /home/$USER/2bwm
sudo make clean install -C /home/$USER/dmenu
cp void-deploy/configs/xinitrc/.xinitrc_2bwm .xinitrc_2bwm
sudo cp void-deploy/configs/xsessions/2bwm.desktop /usr/share/xsessions/2bwm.desktop
cp void-deploy/scripts/2bwm.sh ~/2bwm.sh
sudo chmod +x ~/2bwm.sh
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


## Define FISH Installation and Configuration Function
fish-install () {
sudo xbps-install -S --yes fish-shell
sudo echo /bin/fish | sudo tee -a /etc/shells
mkdir /home/faen/.config/fish
mkdir /home/faen/.config/fish/functions
cp void-deploy/configs/fish_prompt.fish /home/faen/.config/fish/functions/fish_prompt.fish
touch /home/faen/.config/fish/config.fish
echo "set -g fish_greeting" >> /home/faen/.config/fish/config.fish
sudo chsh -s /bin/fish $USER
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
options=("Minimal" "Full" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "Minimal")
      echo "Minimal package installation initialized."
      minimal-install
      echo "Minimal package installation completed."
      break
      ;;
    "Full")
      echo "Full package installation initialized."
      full-install
      echo "Full package installation completed."
      break
      ;;
    "Quit")
      exit 0
      ;;
    *) echo "Invalid option: $REPLY";;
  esac
done


## User Chooses Their Window Manager
PS3='Window Manager: '
options=("DWM" "SOWM" "2BWM" "Continue" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "DWM")
      echo "DWM installation initialized."
      dwm-install
      echo "DWM installation completed."
      ;;
    "SOWM")
      echo "SOWM installation initialized."
      sowm-install
      echo "SOWM installation completed."
      ;;
    "2BWM")
      echo "2BWM installation initialized."
      2bwm-install
      echo "2BWM installation completed."
      ;;
    "Continue")
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
    "Fish")
      echo "Fish selected."
      fish-install
      echo "Fish installation completed."
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



## Make .set_monitor.sh and .set_time.sh executable
sudo chmod +x ~/void-deploy/scripts/.set_monitor.sh
sudo chmod +x ~/void-deploy/scripts/.set_time.sh


## Alacritty Configuration
cd
mkdir ~/.config/alacritty/
cp ~/void-deploy/configs/alacritty.yml ~/.config/alacritty/


## MOC Configuration
mkdir ~/.moc/
cp ~/void-deploy/configs/moc/config ~/.moc/config


## VIM Configuration
cp ~/void-deploy/configs/.vimrc .vimrc
sudo curl https://raw.githubusercontent.com/stayradiated/dotfiles/master/apps/vim/colors/shblah.vim --output /usr/share/vim/vim90/colors/shblah.vim
cd


## Picom Configuration
mkdir ~/.config/picom/
cp void-deploy/configs/picom.conf ~/.config/picom/picom.conf


## Lemonbar Configuration
mkdir ~/.config/lemonbar/
cp void-deploy/scripts/lemonbar.sh ~/.config/lemonbar/lemonbar.sh
sudo chmod +x ~/.config/lemonbar/lemonbar.sh


## Copy fonts
mkdir ~/.fonts
cp ~/void-deploy/fonts/* ~/.fonts
cd ~/.fonts
wget https://github.com/slavfox/Cozette/releases/download/v.1.17.2/cozette_bitmap.ttf
cd


## Zathura configuration
xdg-mime default org.pwmt.zathura.desktop application/pdf
mkdir ~/.config/zathura/
cp ~/void-deploy/configs/zathurarc ~/.config/zathura/zathurarc


## Ranger configuration
mkdir ~/.config/ranger/
sudo cp void-deploy/configs/ranger/* ~/.config/ranger/
sudo chmod +x ~/.config/ranger/scope.sh


## Setup greetd and tuigreet
sudo cp void-deploy/configs/greetd/config.toml /etc/greetd/config.toml
sudo ln -s /etc/sv/greetd /var/service
sudo sv down greetd



### --- REBOOT --- ###



sudo reboot
