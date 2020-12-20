# mod of arcolinuxd install script

# preinstall setup
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist
yay -Syu --noconfirm

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
        or yay -S --noconfirm --needed $1
    fi
}

###############################################################################
echo "Installation of the core software"
###############################################################################

list=(
lightdm
arcolinux-wallpapers-git
xfce4-terminal
arcolinux-xfce-git
arcolinux-local-xfce4-git
qtile
sxhkd
dmenu
feh
python-psutil
xcb-util-cursor
arcolinux-qtile-git
arcolinux-qtile-dconf-git
arcolinux-config-qtile-git
awesome-terminal-fonts
arcolinux-logout-git
pcmanfm
firefox
chromium
qbittorrent
flameshot
discord
simplescreenrecorder
scrot
pulseaudio
pulseaudio-alsa
pavucontrol
alsa-firmware
alsa-lib
alsa-plugins
alsa-utils
gstreamer
gst-plugins-good
gst-plugins-bad
gst-plugins-base
gst-plugins-ugly
playerctl
volumeicon
pulseaudio-bluetooth
bluez
bluez-libs
bluez-utils
blueberry
cups
cups-pdf
ghostscript
gsfonts
gutenprint
gtk3-print-backends
libcups
system-config-printer
tlp
avahi
nss-mdns
gvfs-smb
variety
gimp
inkscape
vlc
evince
dconf-editor
arc-gtk-theme
unace
unrar
zip
unzip
sharutils
uudeview
arj
cabextract
file-roller
mintstick-git
peek
downgrade
hardcode-fixer-git
gtk-engine-murrine
imagemagick
picom
python-pywal
arcolinux-bin-git
arcolinux-hblock-git
arcolinux-root-git
arcolinux-termite-themes-git
arcolinux-tweak-tool-git
arcolinux-variety-git
arcolinux-fonts-git
awesome-terminal-fonts
adobe-source-sans-pro-fonts
adobe-source-code-pro-fonts
cantarell-fonts
noto-fonts
ttf-bitstream-vera
ttf-dejavu
ttf-droid
ttf-hack
ttf-inconsolata
ttf-liberation
ttf-roboto
ttf-ubuntu-font-family
tff-nerd-fonts-symbols
tamsyn-font
terminus-font
nerd-fonts-hack
nerd-fonts-source-code-pro
nerd-fonts-fira-code
nerd-fonts-terminus
conky-lua-archers
arcolinux-conky-collection-git
arcolinux-pipemenus-git
yad
libpulse
asciiquarium
cmatrix
cowsay
figlet
fish
lolcat
pfetch-git
yasm
python-virtualenv
lsd
fortune-mod
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    func_install $name
done

###############################################################################

tput setaf 6
echo "################################################################"
echo "Copying all files and folders from /etc/skel to ~"
echo "################################################################"
echo
tput sgr0
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
cp -arf /etc/skel/. ~

tput setaf 5
echo "################################################################"
echo "Enabling lightdm as display manager"
echo "################################################################"
echo
tput sgr0
sudo systemctl enable lightdm.service -f

tput setaf 5
echo "################################################################"
echo "Change nsswitch.conf for access to nas servers"
echo "################################################################"
echo
tput sgr0

#hosts: files mymachines myhostname resolve [!UNAVAIL=return] dns
#ArcoLinux line
#hosts: files mymachines resolve [!UNAVAIL=return] mdns dns wins myhostname

#first part
sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf
#last part
sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf

tput setaf 5
echo "################################################################"
echo "Enabling services"
echo "################################################################"
echo
tput sgr0

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

sudo systemctl enable org.cups.cupsd.service
sudo systemctl enable tlp.service
sudo systemctl enable avahi-daemon.service

tput setaf 5
echo "################################################################"
echo "Fixing hardcoded icon paths for applications - Wait for it"
echo "################################################################"
echo
tput sgr0
sudo hardcode-fixer

tput setaf 11;
echo "################################################################"
echo "Software installed, making final configurations"
echo "################################################################"
echo
tput sgr0

# final setup
sudo chsh -s /usr/bin/fish $USER
wget https://starship.rs/install.sh
bash install.sh -y
rm install.sh
mkdir ~/.venv
git submodule update --init --recursive
python conf_setup.py

tput setaf 11;
echo "################################################################"
echo "Software has been installed"
echo "################################################################"
echo
tput sgr0
