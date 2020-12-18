# mod of arcolinuxd install script


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
    fi
}

###############################################################################
echo "Installation of the core software"
###############################################################################

list=(
    lightdm
    arcolinux-lightdm-gtk-greeter
    arcolinux-lightdm-gtk-greeter-settings
    arcolinux-wallpapers-git
    thunar
    thunar-archive-plugin
    thunar-volman
    termite
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
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    func_install $name
done
