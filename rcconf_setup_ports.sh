#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this script as root! Thanks."
exit
fi

service ntpdate delete
sysrc sendmail_msp_queueenable="NO"
sysrc sendmail_outbound_enable="NO"
sysrc sendmail_submit_enable="NO"
sysrc ntpd_enable="YES"
sysrc ntpd_flags="-g"
sysrc ntpd_sync_on_start="YES"
sysrc inetd_enable="NO"
sysrc icmp_drop_redirect="YES"
sysrc icmp_log_redirect="YES"
sysrc nfs_server_enable="NO"
sysrc nfs_client_enable="NO"
sysrc sshd_enable="NO"
sysrc portmap_enable="NO"
sysrc mixer_enable="YES"
sysrc allscreens_flags="-f vgarom-8x16.fnt"
sysrc keyrate="fast"
sysrc service_delete_empty="YES"
sysrc firewall_enable="YES"
sysrc firewall_type="workstation"
sysrc firewall_quiet="YES"
sysrc firewall_logdeny="YES"
sysrc autoboot="YES"
sysrc rc_fast="YES"
sysrc dbus_enable="YES"
sysrc rc_startmsgs="NO"
sysrc blanktime="1200"
sysrc savecore_enable="NO"
sysrc virecover_enable="NO"
sysrc vboxnet_enable="YES"
sysrc smartd_enable="YES"
sysrc dumpdev="NO"
sysrc apm_enable="YES"

# Set up DRM kmod support for graphics cards.
cd /usr/ports/graphics/drm-kmod && make install clean

read -p "FreeBSD DRM kmod graphics support has been installed. What kind of graphics card do you have?
1.) AMD GPU
2.) ATI Radeon
3.) NVIDIA
4.) Intel
5.) VirtualBox
6.) VMware
> " resp

if [ 0"$resp" = 01 ]; then
sysrc kld_list+=amdgpu
fi
#
if [ 0"$resp" = 02 ]; then
sysrc kld_list+=radeon
fi
#
if [ 0"$resp" = 03 ]; then
cd /usr/ports/x11/nvidia-driver && make install clean ; sysrc kld_list+=nvidia nvidia-modeset ; cd
fi
#
if [ 0"$resp" = 04 ]; then
sysrc kld_list+=i915kms
fi
#
if [ 0"$resp" = 05 ]; then
cd /usr/ports/emulators/virtualbox-ose-additions-legacy && make install clean
cd /usr/ports/x11-drivers/xf86-video-vmware && make install clean ; service vboxguest enable && service vboxservice enable
pw groupmod vboxusers -m $USER
fi
#
if [ 0"$resp" = 06 ]; then
cd /usr/ports/x11-drivers/xf86-video-vmware && make install clean
cd /usr/ports/emulators/open-vm-tools && make install clean
fi
cd /home/$USER/freebsd-setup-scripts
