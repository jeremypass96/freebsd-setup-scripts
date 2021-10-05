#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use. Run this script as root.
echo 'kld_list="amdgpu"' >> /etc/rc.conf
echo 'sendmail_msp_queue_enable="NO"' >> /etc/rc.conf
echo 'sendmail_outbound_enable="NO"' >> /etc/rc.conf
echo 'sendmail_submit_enable="NO"' >> /etc/rc.conf
service ntpdate delete
echo 'ntpd_enable="YES"' >> /etc/rc.conf
echo 'ntpd_sync_on_start="YES"' >> /etc/rc.conf
sed -i '' s/dumpdev="AUTO"/dumpdev="NO"/g /etc/rc.conf
echo 'inetd_enable="NO"' >> /etc/rc.conf
echo 'icmp_drop_redirect="YES"' >> /etc/rc.conf
echo 'icmp_log_redirect="YES"' >> /etc/rc.conf
echo 'nfs_server_enable="NO"' >> /etc/rc.conf
echo 'nfs_client_enable="NO"' >> /etc/rc.conf
echo 'sshd_enable="NO"' >> /etc/rc.conf
echo 'portmap_enable="NO"' >> /etc/rc.conf
echo 'mixer_enable="YES"' >> /etc/rc.conf
echo 'allscreens_flags="-f vgarom-8x16.fnt"' >> /etc/rc.conf
echo 'keyrate="fast"' >> /etc/rc.conf
echo 'service_delete_empty="YES"' >> /etc/rc.conf
echo 'firewall_enable="YES"' >> /etc/rc.conf
echo 'firewall_type="workstation"' >> /etc/rc.conf
echo 'firewall_quiet="YES"' >> /etc/rc.conf
echo 'firewall_logging="YES"' >> /etc/rc.conf
echo 'autoboot="YES"' >> /etc/rc.conf
echo 'rc_fast="YES"' >> /etc/rc.conf
echo 'dbus_enable="YES"' >> /etc/rc.conf
echo 'rc_startmsgs="NO"' >> /etc/rc.conf
echo 'cupsd_enable="YES"' >> /etc/rc.conf
echo 'saned_enable="YES"' >> /etc/rc.conf
echo 'lightdm_enable="YES"' >> /etc/rc.conf
echo 'blanktime="1200"' >> /etc/rc.conf
echo 'scrnmap="NO"' >> /etc/rc.conf
echo 'savecore_enable="NO"' >> /etc/rc.conf
echo 'virecover_enable="NO"' >> /etc/rc.conf
echo 'vboxnet_enable="YES"' >> /etc/rc.conf
echo 'webcamd_enable="YES"' >> /etc/rc.conf
