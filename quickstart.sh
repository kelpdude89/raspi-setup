!#/bin/bash

# script for optimizing the RaspberryPi for headless use
# includes:
# 	lowering power consumption
# 	lowering RAM utilization
# 	lowering CPU usage
# 	disable hardware not necessary for Pi when headless

# Colored text
RED='\033[0;31m'
OFF='\033[0m'

# root user check

WHOAMI=`id -u`

if [ $WHOAMI -gt 0 ]; then
	echo -e "${RED}You must use sudo to run this script.${OFF}"
	echo "sudo $0"
	exit 1
fi

# var - start

read -p "Enter a Hostname: " HNAME
read -p "Enter the IP address to assign to RaspberryPi: " HIP
read -p "Enter the IP address of the DNS server for the RaspberryPi: " HDNS
read -p "Enter the IP address of your router: " ROUTERIP

# var - stop

# func - start

noBluetooth(){
	echo "# Disable Bluetooth" >> /boot/config.txt
	echo "dtoverlay=disable-bt" >> /boot/config.txt
	systemctl stop bluetooth.service
	systemctl disable bluetooth.service
	systemctl mask bluetooth.service
	systemctl stop bluetooth.target
	systemctl disable bluetooth.target
	systemctl mask bluetooth.target
}

noHDMI(){
	echo "# Disable HDMI" >> /boot/config.txt
	echo "hdmi_blanking=2" >> /boot/config.txt
}

noWIFI(){
	echo "# Disable HDMI" >> /boot/config.txt
	echo "hdmi_blanking=2" >> /boot/config.txt
}

noAUDIO(){
	echo "blacklist snd_bcm2835" > /etc/modprobe.d/alsa-blacklist.conf
	systemctl stop alsa-state.service
	systemctl stop alsa-restore.service
	systemctl disable alsa-restore.service
	systemctl disable alsa-state.service
	systemctl mask alsa-state.service
	systemctl mask alsa-restore.service
}

noIP6(){
	echo "net.ipv6.conf.$INTERFACE.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.$MONINTERFACE.disable_ipv6 = 1" >> /etc/sysctl.conf
}

# func - stop

# start script

# get IP info
read -p 'Enter the hostname for this RaspberryPi: ' HNAME
read -p 'Enter an static IP address: ' HIP
read -p 'Enter a DNS server address: ' HDNS
read -p 'Enter the router IP: ' ROUTERIP

sleep 1
echo 'Setting IP and Hostname now.'

# set static IPs
echo "interface $INTERFACE" >> /etc/dhcpcd.conf
echo "static ip_address=$HIP/24" >> /etc/dhcpcd.conf
echo "static routers=$ROUTERIP" >> /etc/dhcpcd.conf
echo "static domain_name_servers=$HDNS" >> /etc/dhcpcd.conf

# Set Hostname
hostnamectl set-hostname $HNAME
echo "127.0.0.1       localhost" > /etc/hosts
echo "::1	     localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1        ip6-allnodes" >> /etc/hosts
echo "ff02::02       ip6-allrouters" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1                  $HNAME" >> /etc/hosts
echo "127.0.1.1                 $HNAME" >> /etc/hosts

# Disable HW at boot
echo "" >> /boot/config.txt

# One, some, or All?

echo 'Do you want to enable all configurations to maximize your RaspberryPi?'
echo '[!] Note this will disable WiFi and HDMI so if you are not running headless on Ethernet you will not be able to connect'
read -p ' [y/N]: ' all_dis
case $all_dis in
	y | Y | yes | YES | Yes)
		noWIFI
		noIP6
		noHDMI
		noAUDIO
		noBluetooth
		apt get update -y
		apt get full-upgrade -y
		reboot
		;;
esac

echo 'Do you want to disable WiFi?'
read -p ' [y/N]: ' wifi_dis
case $wifi_dis in
	y | Y | yes | YES | Yes)
		noWIFI
		;;
esac

# Bluetooth
echo 'Do you want to disable Bluetooth?'
read -p '[y/N]: ' bt_dis
case $bt_dis in
	y | Y | yes | YES | Yes)
		noBluetooth
		;;
esac

# HDMI
echo 'Do you want to disable HDMI port(s)?'
read -p '[y/N]: ' hdmi_dis
case $hdmi_dis in
	y | Y | yes | YES | Yes) 
		noHDMI
		;;
esac

# Disable Audio
echo 'Do you want to disable Audio?'
read -p '[y/N]: ' audio_dis
case $audio_dis in
	y | Y | yes | YES | Yes)
		noAUDIO
		;;
esac

# disable ipv6
echo 'Do you want to disable IPv6?'
read -p '[y/N]: ' ipv6_dis
case $ipv6_dis in
	y | Y | yes | YES | Yes)
		noIP6
		;;
esac

# Update and reboot system
apt update -y
apt upgrade -y
reboot

# End of Script