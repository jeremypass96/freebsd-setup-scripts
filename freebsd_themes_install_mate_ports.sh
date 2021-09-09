#!/bin/sh
cd
#
clear
# Install the Greybird GTK theme.
echo "Installing the Greybird GTK theme..."
sud portmaster x11-themes/greybird-theme
#
clear
# Install Kvantum Qt5 theme manager.
echo "Installing the Kvantun Qt5 theme manager..."
sudo portmaster x11-themes/Kvantum
cd
git clone https://github.com/varlesh/greybird-kde.git
cd greybird-kde/Kvantum
sudo cp -rv Greybird /usr/local/share/Kvantum/
cd && rm -rf greybird-kde
#
clear
# Install Newaita icon theme with FreeBSD logo for Applications menu.
echo "Installing the Newaita icon theme with FreeBSD logo for Applications menu..."
cd
git clone https://github.com/cbrnix/Newaita.git
cd Newaita/
sudo cp -rv Newaita /usr/local/share/icons/
cd /usr/local/share/icons/Newaita/
clear
## Change "rm -f" to "rm -rf"
echo "Changing "rm -f" to "rm -rf" first before we can execute."
sudo micro FV.sh
##
sudo ./FV.sh
## Change "rm -f" to "rm -rf"
echo "Changing "rm -f" to "rm -rf" first before we can execute."
sudo micro PV.sh
##
sudo ./PV.sh
cd places/24
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd ../32
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd ../48
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd ../64
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd && rm -rf Newaita
#
clear
# Install Qogir mouse cursors.
echo "Installing Qogir mouse cursors..."
git clone https://github.com/vinceliuice/Qogir-icon-theme.git && cd Qogir-icon-theme/src/cursors/
sudo ./install.sh
cd && rm -rf Qogir-icon-theme/
#
clear
# Install the Mojave GTK theme (for window borders ony).
echo "Installing Mojave GTK theme (for window borders only)..."
sudo portmaster x11-themes/mojave-gtk-themes
#
clear
# Installing fonts.
echo "Installing fonts..."
sudo portmaster x11-fonts/ubuntu-font
sudo portmaster x11-fonts/sourcecodepro-ttf
sudo portmaster x11-fonts/webfonts
#
# Install the Vertex GTK theme.
echo "Installing the Vertex GTK theme (for LightDM login screen)..."
sudo portmaster x11-themes/gnome-themes-extra x11-themes/gtk-murrine-engine devel/autoconf devel/automake devel/pkgconf x11-toolkits/tk30
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr/local --disable-gnome-shell --disable-light --disable-unity --disable-xfwm --with-gnome=3.22
sudo make install
cd
rm -rf vertex-theme/
#