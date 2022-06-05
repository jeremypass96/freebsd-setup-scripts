#!/usr/local/bin/bash
cmd=(dialog --separate-output --no-cancel --checklist "Would you like to install any extra 3rd party software?" 21 70 21)
options=(1 "Audacity (audio editor)" off
         2 "Handbrake (video file converter)" off
         3 "ISO Master (ISO file editor)" off
         4 "AbiWord (word processor)" off
         5 "Gnumeric (speadsheet)" off
         6 "Transmission (torrent downloader)" off
         7 "Asunder (CD ripper)" off
         8 "GIMP (image editor)" off
         9 "Inkskape (vector graphics editor)" off
         10 "Pinta (image editor similar to Paint.NET on Windows)" off
         11 "Shotwell (photo organizer/editor)" off
         12 "VirtualBox (run multiple operating systems on your PC)" off
         13 "Wine (run Windows applications)" off
         n "No, don't install any 3rd party software." off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1) pkg="audacity";;
        2) pkg="handbrake";;
        3) pkg="isomaster";;
        4) pkg="abiword";;
        5) pkg="gnumeric";;
        6) pkg="transmission-gtk";;
        7) pkg="asunder";;
        8) pkg="gimp";;
        9) pkg="inkscape";;
        10) pkg="pinta";;
        11) pkg="shotwell";;
        12) pkg="virtualbox-ose virtualbox-ose-kmod"
        sysrc vboxnet_enable="YES"
        echo "### VirtualBox stuff ###" >> /etc/sysctl.conf
        echo vfs.aio.max_buf_aio=8192 >> /etc/sysctl.conf
        echo vfs.aio.max_aio_queue_per_proc=65536 >> /etc/sysctl.conf
        echo vfs.aio.max_aio_per_proc=8192 >> /etc/sysctl.conf
        echo vfs.aio.max_aio_queue=65536 >> /etc/sysctl.conf;;
        13) pkg="wine wine-mono wine-gecko"
        echo "# Wine fix" >> /boot/loader.conf
        echo machdep.max_ldt_segment=2048 >> /boot/loader.conf;;
        n) continue
    esac
    pkg install -y $pkg
    clear
done
