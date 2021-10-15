#!/bin/sh
# This shell script sets up FreeBSD's loader.conf bootloader variables for desktop use. Run this script as root.
echo 'cuse_load="YES"' >> /boot/loader.conf
echo 'cc_cubic_load="YES"' >> /boot/loader.conf
echo 'kern.random.fortuna.minpoolsize="512"' >> /boot/loader.conf
echo 'amdsbwd_load="YES"' >> /boot/loader.conf
echo 'amdtemp_load="YES"' >> /boot/loader.conf
echo "loader_delay=0" >> /boot/loader.conf
echo "autoboot_delay=-1" >> /boot/loader.conf
echo 'beastie_disable="YES"' >> /boot/loader.conf
echo 'cpu_microcode_load="YES"' >> /boot/loader.conf
echo 'cpu_microcode_name="/boot/firmware/intel-ucode.bin"' >> /boot/loader.conf
echo 'fusefs_load="YES"' >> /boot/loader.conf
echo 'libiconv_load="YES"' >> /boot/loader.conf
echo 'libmchain_load="YES"' >> /boot/loader.conf
echo 'cd9660_iconv_load="YES"' >> /boot/loader.conf
echo 'msdosfs_iconv_load="YES"' >> /boot/loader.conf
echo "kern.ipc.shmseg=10000" >> /boot/loader.conf
echo "kern.ipc.shmmni=10000" >> /boot/loader.conf
echo "kern.maxproc=100000" >> /boot/loader.conf
echo "hw.usb.no_boot_wait=1" >> /boot/loader.conf
echo "hw.usb.no_shutdown_wait=1" >> /boot/loader.conf
echo "hw.spec_store_bypass_disable=2" >> /boot/loader.conf
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

# Set up CPU microcode updates.
cd /usr/ports/sysutils/devcpu-data && make install clean

# Reboot to apply changes.
reboot