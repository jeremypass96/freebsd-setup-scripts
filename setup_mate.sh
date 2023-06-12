#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD MATE setup script."
echo "This script will setup Xorg, MATE, some useful software for you, along with the rc.conf file being tweaked for desktop use. Also, don't forget to run './mate_theme_install.sh' after you reboot."
echo ""
read -p "Press the Enter key to continue..." resp

clear

read -p "Do you plan to install software via pkg (binary packages) or ports (FreeBSD Ports tree)? (pkg/ports): " resp
if [ "$resp" = pkg ]; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF > /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF
pkg update
echo ""

# Make pkg use sane defaults.
echo "" >> /usr/local/etc/pkg.conf
echo "# Make pkg use sane defaults." >> /usr/local/etc/pkg.conf
echo DEFAULT_ALWAYS_YES=yes >> /usr/local/etc/pkg.conf
echo AUTOCLEAN=yes >> /usr/local/etc/pkg.conf

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y cups cups-filters cups-pk-helper gutenprint system-config-printer
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sysrc avahi_daemon_enable="YES"
sysrc avahi_dnsconfd_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size? (letter/a4): " resp
if [ "$resp" = letter ]; then
pkg install -y papersize-default-letter
fi
if [ "$resp" = a4 ]; then
pkg install -y papersize-default-a4
fi
read -p "Do you own an HP printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y hplip
fi
if [ "$resp" = n ]; then
continue
fi
fi
if [ "$resp" = n ]; then
continue
fi

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji mate parole xfburn qt5ct qt5-style-plugins ulauncher ungoogled-chromium webfonts micro xclip zsh ohmyzsh neofetch pfetch octopkg lightdm slick-greeter mp4v2 skeuos-gtk-themes papirus-icon-theme numlockx devcpu-data automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf plex-ttf xdg-user-dirs duf btop colorize freedesktop-sound-theme rkhunter chkrootkit topgrade bat fd-find lsd nerd-fonts

clear

# Setup rc.conf file.
./rcconf_setup.sh

# Install 3rd party software.
./software_dialog_pkgs.sh

# Install BSDstats.
read -p "Would you like to enable BSDstats? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y bsdstats
sysrc bsdstats_enable="YES"
echo 'monthly_statistics_enable="YES"' >> /etc/periodic.conf
fi
if [ "$resp" = n ]; then
continue
fi
fi

if [ "$resp" = ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/'# REFUSE arabic chinese french german hebrew hungarian japanese'/'REFUSE arabic chinese french german hebrew hungarian japanese'/g /etc/portsnap.conf
sed -i '' s/'# REFUSE korean polish portuguese russian ukrainian vietnamese'/'REFUSE korean polish portuguese russian ukrainian vietnamese'/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
echo "" >> /etc/make.conf
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/cups-filters && make install clean
cd /usr/ports/print/cups-pk-helper && make install clean
cd /usr/ports/print/gutenprint && make install clean
cd /usr/ports/print/system-config-printer && make install clean
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sysrc avahi_daemon_enable="YES"
sysrc avahi_dnsconfd_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size? (letter/a4): " resp
if [ "$resp" = letter ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ "$resp" = a4 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
read -p "Do you own an HP printer? (y/n): " resp
if [ "$resp" = y ]; then
cd /usr/ports/print/hplip && make install clean
sed -i '' '24s/$/print_hplip_UNSET=X11/' /etc/make.conf
fi
if [ "$resp" = n ]; then
continue
fi
fi
if [ "$resp" = n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

clear

# Install Ports.
cd /usr/ports/shells/bash && make install clean
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/sysutils/pfetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/mate && make install clean
cd /usr/ports/math/galculator && make install clean
cd /usr/ports/multimedia/parole && make install clean
cd /usr/ports/sysutils/xfburn && make install clean
cd /usr/ports/misc/qt5ct && make install clean
cd /usr/ports/x11-themes/qt5-style-plugins && make install clean
cd /usr/ports/x11/ulauncher && make install clean
cd /usr/ports/www/ungoogled-chromium && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11-themes/skeuos-gtk-themes && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/sysutils/fusefs-simple-mtpfs && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean
cd /usr/ports/x11-fonts/ubuntu-font && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/plex-ttf && make install clean
cd /usr/ports/devel/xdg-user-dirs && make install clean
cd /usr/ports/sysutils/duf && make install clean
cd /usr/ports/sysutils/btop && make install clean
cd /usr/ports/sysutils/colorize && make install clean
cd /usr/ports/audio/freedesktop-sound-theme && make install clean
cd /usr/ports/security/rkhunter && make install clean
cd /usr/ports/security/chkrootkit && make install clean
cd /usr/ports/sysutils/topgrade && make install clean
cd /usr/ports/textproc/bat && make install clean
cd /usr/ports/sysutils/fd && make install clean
cd /usr/ports/sysutils/lsd && make install clean
cd /usr/ports/x11-fonts/nerd-fonts && make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

clear

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

clear

# Install 3rd party software.
./software_dialog_ports.sh

clear

# Install BSDstats.
read -p "Would you like to enable BSDstats? (y/n): " resp
if [ "$resp" = y ]; then
portmaster --no-confirm sysutils/bsdstats
sysrc bsdstats_enable="YES"
echo 'monthly_statistics_enable="YES"' >> /etc/periodic.conf
fi
if [ "$resp" = n ]; then
continue
fi
fi

clear

# Download Pluma text editor color scheme.
fetch https://raw.githubusercontent.com/isdampe/gedit-gtk-one-dark-style-scheme/master/onedark-bright.xml -o /usr/local/share/gtksourceview-4/styles/onedark-bright.xml

# Install cursor theme.
echo "Installing the "Bibata Modern Ice" cursor theme..."
fetch https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Ice.tar.gz -o /home/$USER/Bibata-Modern-Ice.tar.gz
tar -xvf /home/$USER/Bibata-Modern-Ice.tar.gz -C /usr/local/share/icons
rm -rf /home/$USER/Bibata-Modern-Ice.tar.gz

# Setup LightDM.
sysrc lightdm_enable="YES"
sed -i '' s/'#pam-autologin-service=lightdm-autologin'/'pam-autologin-service=lightdm-autologin'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#allow-user-switching=true'/'allow-user-switching=true'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#allow-guest=true'/'allow-guest=false'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#greeter-setup-script='/'greeter-setup-script=numlockx on'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#autologin-user='/'autologin-user=$USER'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#autologin-user-timeout=0'/'autologin-user-timeout=0'/g /usr/local/etc/lightdm/lightdm.conf
mkdir /usr/local/etc/lightdm/wallpaper
fetch https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate13.0/files/wallpaper/centerFlat_grey-4k.png -o /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
chown root:wheel /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png

# Setup slick greeter.
cat << EOF > /usr/local/etc/lightdm/slick-greeter.conf
[Greeter]
background = /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
draw-user-backgrounds = false
draw-grid = false
show-hostname = true
show-a11y = false
show-keyboard = false
clock-format = %I:%M %p
theme-name = Papirus-Light
icon-theme-name = Skeuos-Blue-Light
EOF

# Setup qt5ct and fix GTK/QT antialiasing.
mkdir /home/$USER/.config/qt5ct
chown -R $USER:$USER /home/$USER/.config/qt5ct
mkdir -p /usr/share/skel/dot.config/qt5ct
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/qt5ct/qt5ct.conf /home/$USER/.config/qt5ct/qt5ct.conf
cp -v /home/$USER/.config/qt5ct/qt5ct.conf /usr/share/skel/dot.config/qt5ct/qt5ct.conf
chown $USER:$USER /home/$USER/.config/qt5ct/qt5ct.conf
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/.xinitrc /home/$USER/.xinitrc
cp -v /home/$USER/.xinitrc /usr/share/skel/.xinitrc
chown $USER:$USER /home/$USER/.xinitrc

# Hide menu items.
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_assistant.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_designer.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_linguist.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gnome.Glade.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.Demo4.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.IconBrowser4.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.PrintEditor.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.WidgetFactory4.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.gtk4.NodeEditor.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.PrintEditor4.desktop
sed -i '' s/"Development;"/\/g /usr/local/share/applications/micro.desktop

# Fix user's .xinitrc permissions.
chown $USER:$USER /home/$USER/.xinitrc

# Fix user's config directory permissions.
chown -R $USER:$USER /home/$USER/.config

# Fix user's local directory permissions.
chown -R $USER:$USER /home/$USER/.local

# Create and fix user's caja config directory permissions.
mkdir -p /home/$USER/.config/caja
chown -R $USER:$USER /home/$USER/.config/caja

# Install Ulauncher theme.
mkdir -p /home/$USER/.config/ulauncher/user-themes
git clone https://github.com/SylEleuth/ulauncher-gruvbox /home/$USER/.config/ulauncher/user-themes/gruvbox-ulauncher
chown -R $USER:$USER /home/$USER/.config/ulauncher
mkdir -p /usr/share/skel/dot.config/ulauncher/user-themes
cp -r /home/$USER/.config/ulauncher/user-themes/gruvbox-ulauncher /usr/share/skel/dot.config/ulauncher/user-themes/gruvbox-ulauncher
cp -rv /home/$USER/freebsd-setup-scripts/Dotfiles/config/ulauncher/settings.json /usr/share/skel/dot.config/ulauncher/settings.json

# Configure rkhunter (rootkit malware scanner).
echo 'daily_rkhunter_update_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_update_flags="--update"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_flags="--checkall --skip-keypress"' >> /etc/periodic.conf

# Get wallpapers!
echo "Getting wallpapers..."
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0004.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0011.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0023.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0036.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0037.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0042.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0057.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0058.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0065.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0076.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0188.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0230.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0252.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0256.jpg -o /usr/local/share/backgrounds
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0257.jpg -o /usr/local/share/backgrounds
fetch https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Field_Of_Lightning.jpg -o /usr/local/share/backgrounds
fetch https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Lake_View.jpg -o /usr/local/share/backgrounds
fetch https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Mountain_View.jpg -o /usr/local/share/backgrounds
fetch https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Wood_Trail.jpg -o /usr/local/share/backgrounds
fetch https://w.wallhaven.cc/full/5g/wallhaven-5gkk65.jpg -o /usr/local/share/backgrounds
