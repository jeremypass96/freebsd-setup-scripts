#!/bin/sh

# Final setup stage.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

cd Dotfiles/

# Copy over .profile & fix system profile file.
cp -v .profile /home/$USER
cp -v .profile /usr/share/skel/dot.profile
chown $USER:$USER /home/$USER/.profile
echo "EDITOR=micro;   export EDITOR" >> /etc/profile
echo "PAGER=less;   export PAGER" >> /etc/profile
echo "BAT_THEME="1337";	export BAT_THEME" >> /etc/profile

# Copy over zsh config.
cp -v .zshrc /home/$USER
cp -v .zshrc /usr/share/skel/dot.zshrc
chown $USER:$USER /home/$USER/.zshrc

# Copy over neofetch config.
mkdir -p /home/$USER/.config/neofetch
cp -v config/neofetch/config.conf /home/$USER/.config/neofetch/
mkdir -p /root/.config/neofetch/
cp -v config/neofetch/config.conf /root/.config/neofetch/
mkdir -p /usr/share/skel/dot.config/neofetch
cp -v config/neofetch/config.conf /usr/share/skel/dot.config/neofetch/
chown -R $USER:$USER /home/$USER/.config/neofetch

# Copy over micro config.
mkdir -p /home/$USER/.config/micro
cp -v config/micro/settings.json /home/$USER/.config/micro/
mkdir -p /root/.config/micro/
cp -v config/micro/settings.json /root/.config/micro/
mkdir -p /usr/share/skel/dot.config/micro
cp -v config/micro/settings.json /usr/share/skel/dot.config/micro/
chown -R $USER:$USER /home/$USER/.config/micro

# Change shell to zsh.
chsh -s /usr/local/bin/zsh $USER

# Get "zsh-autosuggestions" and "zsh-syntax-highlighting" Oh My Zsh plugins.
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/local/share/ohmyzsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/ohmyzsh/custom/plugins/zsh-syntax-highlighting

# Copy over lsd config.
mkdir -p /home/$USER/.config/lsd
cp -v config/lsd/config.yaml /home/$USER/.config/lsd/
mkdir -p /root/.config/lsd/
cp -v config/lsd/config.yaml /root/.config/lsd/
mkdir -p /usr/share/skel/dot.config/lsd
cp -v config/lsd/config.yaml /usr/share/skel/dot.config/lsd/
chown -R $USER:$USER /home/$USER/.config/lsd
