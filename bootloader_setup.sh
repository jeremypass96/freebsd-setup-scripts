#!/bin/sh
# This shell script sets up FreeBSD's loader.conf bootloader variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this bootloader setup script as root! Thanks."
exit
fi

sysrc -f /boot/loader.conf cuse_load="YES"
sysrc -f /boot/loader.conf cc_cubic_load="YES"
echo 'kern.random.fortuna.minpoolsize="512"' >> /boot/loader.conf

read -p "Do you have an AMD CPU installed in your computer? (y/n): " resp
if [ "$resp" = y ]; then
sysrc -f /boot/loader.conf amdsbwd_load="YES"
sysrc -f /boot/loader.conf amdtemp_load="YES"
fi
if [ "$resp" = n ]; then
sysrc -f /boot/loader.conf coretemp_load="YES"
fi

sysrc -f /boot/loader.conf loader_delay=0
sysrc -f /boot/loader.conf autoboot_delay=-1
sysrc -f /boot/loader.conf beastie_disable="YES"
#sysrc -f /boot/loader.conf boot_mute="YES"
sysrc -f /boot/loader.conf cpu_microcode_load="YES"
sysrc -f /boot/loader.conf cpu_microcode_name="/boot/firmware/intel-ucode.bin"
sysrc -f /boot/loader.conf fusefs_load="YES"
sysrc -f /boot/loader.conf libiconv_load="YES"
sysrc -f /boot/loader.conf libmchain_load="YES"
sysrc -f /boot/loader.conf cd9660_iconv_load="YES"
sysrc -f /boot/loader.conf msdosfs_iconv_load="YES"
echo kern.ipc.shmseg=10000 >> /boot/loader.conf
echo kern.ipc.shmmni=10000 >> /boot/loader.conf
echo hw.usb.no_boot_wait=1 >> /boot/loader.conf
echo hw.usb.no_shutdown_wait=1 >> /boot/loader.conf
echo kern.geom.label.disk_ident.enable=0 >> /boot/loader.conf
echo kern.geom.label.gptid.enable=0 >> /boot/loader.conf

# Protects against "Meltdown" security mitigation.
echo vm.pmap.pti=1 >> /boot/loader.conf

# Protects against "Varient 4" security mitigation.
echo hw.spec_store_bypass_disable_active=1 >> /boot/loader.conf

# Power off devices without attached driver.
echo hw.pci.do_power_nodriver=2 >> /boot/loader.conf

echo "########################################################################" >> /boot/loader.conf
echo "### Custom VT Colors - Andromeda (from iTerm2 Color Schemes project) ###" >> /boot/loader.conf
echo "########################################################################" >> /boot/loader.conf
echo 'kern.vt.color.0.rgb="#000000"' >> /boot/loader.conf
echo 'kern.vt.color.1.rgb="#cd3131"' >> /boot/loader.conf
echo 'kern.vt.color.2.rgb="#05bc79"' >> /boot/loader.conf
echo 'kern.vt.color.3.rgb="#e5e512"' >> /boot/loader.conf
echo 'kern.vt.color.4.rgb="#2472c8"' >> /boot/loader.conf
echo 'kern.vt.color.5.rgb="#bc3fbc"' >> /boot/loader.conf
echo 'kern.vt.color.6.rgb="#0fa8cd"' >> /boot/loader.conf
echo 'kern.vt.color.7.rgb="#e5e5e5"' >> /boot/loader.conf
echo 'kern.vt.color.8.rgb="#666666"' >> /boot/loader.conf
echo 'kern.vt.color.9.rgb="#cd3131"' >> /boot/loader.conf
echo 'kern.vt.color.10.rgb="#05bc79"' >> /boot/loader.conf
echo 'kern.vt.color.11.rgb="#e5e512"' >> /boot/loader.conf
echo 'kern.vt.color.12.rgb="#2472c8"' >> /boot/loader.conf
echo 'kern.vt.color.13.rgb="#bc3fbc"' >> /boot/loader.conf
echo 'kern.vt.color.14.rgb="#0fa8cd"' >> /boot/loader.conf
echo 'kern.vt.color.15.rgb="#e5e5e5"' >> /boot/loader.conf
echo "########################################################################" >> /boot/loader.conf
