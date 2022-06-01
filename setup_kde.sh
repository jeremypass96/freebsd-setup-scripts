#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD Xfce setup script."
echo "This script will setup Xorg, Xfce, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press any key to continue..." resp

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

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y cups gutenprint system-config-printer hplip
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size? (Letter/A4): " resp
if [ "$resp" = Letter ]; then
pkg install -y papersize-default-letter
fi
if [ "$resp" = A4 ]; then
pkg install -y papersize-default-a4
fi
fi
if [ "$resp" = n ]; then
continue
fi

clear

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji plasma5-plasma kde-baseapps kdeadmin kdeutils spectacle gwenview sddm plasma5-sddm-kcm papirus-icon-theme chromium webfonts micro xclip zsh ohmyzsh neofetch mp4v2 numlockx devcpu-data automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf colorize freedesktop-sound-theme

clear

# Setup rc.conf file.
./rcconf_setup.sh

# Install 3rd party software.
./software_dialog_pkgs.sh
pkg clean -y
fi

if [ "$resp" = ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/'#REFUSE arabic chinese french german hebrew hungarian japanese'/'REFUSE arabic chinese french german hebrew hungarian japanese'/g /etc/portsnap.conf
sed -i '' s/'#REFUSE korean polish portuguese russian ukrainian vietnamese'/'REFUSE korean polish portuguese russian ukrainian vietnamese'/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

clear

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
sed -i '' '26s/$/print_hplip_UNSET=X11/' /etc/make.conf
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/gutenprint && make install clean
cd /usr/ports/print/system-config-printer && make install clean
cd /usr/ports/print/hplip && make install clean
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size? (Letter/A4): " resp
if [ "$resp" = Letter ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ "$resp" = A4 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
fi
if [ "$resp" = n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

# make.conf options for KDE.
echo "KDE Options" >> /etc/make.conf
echo "x11_kde5_UNSET=KDEEDU KDEGAMES KDEGRAPHICS KDEMULTIMEDIA KDENETWORK KDEPIM" >> /etc/make.conf

clear

# Install Ports.
cd /usr/ports/shells/bash && make install clean
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/kde5 && make install clean
cd /usr/ports/graphics/spectacle && make install clean
cd /usr/ports/graphics/gwenview && make install clean
cd /usr/ports/x11/sddm && make install clean
cd /usr/ports/deskutils/plasma5-sddm-kcm && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/www/chromium && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/sysutils/fusefs-simple-mtpfs && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean
cd /usr/ports/x11-fonts/ubuntu-font && make install clean
cd /usr/ports/x11-fonts/office-code-pro && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && make install clean
cd /usr/ports/devel/xdg-user-dirs && make install clean
cd /usr/ports/sysutils/duf && make install clean
cd /usr/ports/sysutils/colorize && make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

# Install 3rd party software.
./software_dialog_ports.sh
fi

clear

# Enable SDDM (Simple Desktop Display Manager) on boot.
sysrc sddm_enable="YES"

# Install cursor theme.
echo "Installing the "Volantes Light Cursors" cursor theme..."
tar -xf volantes_light_cursors.tar.gz -C /usr/local/share/icons

# Fix GTK/QT antialiasing
cat << EOF > /home/$USER/.xinitrc
# GTK/QT Antialiasing
export QT_XFT=1
export GDK_USE_XFT=1
EOF