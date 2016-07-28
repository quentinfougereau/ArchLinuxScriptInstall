#!/bin/bash

parted -l #List partition to help user to choose

#l'option -p associe un message à la commande 'read'
read -p "Please, write a disk where you want to install ArchLinux (ie : /dev/sda) : " part

read -p "Are you sure ? All data will be removed (y/n)" res
case $res in
[y])
 

###mklabel allow to choose the type of the disk
#parted --script $part mklabel gpt \
#mkpart ESP fat32 1MiB 513MiB \
#read -p "Root partition from (GiB) : " beg
#read -p "to (Gib) : " end
#mkpart primary ext4 $beg $end \
#read -p "Swap partition from (GiB) : " beg
#read -p "to (GiB) : " end
#mkpart primary linux-swap beg end \
#read -p "Home partition from (GiB) : " beg
#read -p "to (GiB) or type 100% : " end
#mkpart primary ext4 beg end
#echo "Set up and activate swap : "


#mkswap $part"3"
#swapon $part"3" 


###Mount the root partition to the /mnt directory
#mount $part"2"

###Mount the ESP to the /mnt/boot 
#mkdir -p /mnt/boot
#mount $part"1" /mnt/boot

###Mount the home partition ?


### enable interface eth0 (wired)
systemctl enable dhcpcd@eth0.service


tmpfile=/tmpfile
url="https://www.archlinux.org/mirrorlist/?country=FR"
### -s > silent mode (not show message and error) --output <file> > write output to a file
#curl -s --output ${tmpfile} ${url}
#mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.original
#mv ${tmpfile} /etc/pacman.d/mirrorlist
#sed -i "7,9s/#Server/Server/" /etc/pacman.d/mirrorlist


### Install the base system
#pacstrap -i /mnt base base-devel


###Attribute UUID to partitions (-U)
#genfstab -U  /mnt >> /mnt/etc/fstab




######### Configure the base system (chroot)
#arch-chroot /mnt /bin/bash


### Set locale in /etc/locale.gen
#sed -i "s/#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen
### Then generate locale
#locale-gen

#lang="LANG=fr_FR.UTF-8"
#echo $lang > /etc/locale.conf


### tzselect
### mkinitcpio



### systemd boot
#bootctl --path=esp install
###Basic configuration
##editor : enable the kernel parameters editor or not. 1 (default) to enable and 0 to disable
echo "default  arch\ntimeout  4 \neditor   0" > /home/quentin/Documents/test.txt
archconf="title     Arch Linux\nlinux     /vmlinuz-linux\ninitrd    /initramfs-linux.img\noptions   root=${part}'2' rw"
echo ${archconf} > /esp/loader/entries/arch.conf


### Install package for wi-fi
pacman -S iw wpa_supplicant dialog
### Activate wi-fi now ?



###Set the root password
passwd



###Install xorg
pacman -Syu xorg-server xorg-init xorg-server-utils
###Install graphic driver ?
###Configure keypad and monitor ?


###Install the gnome package
pacman -S gnome gnome-extra gnome-system-tools
pacman -S gdm
systemctl enable gdm.service

###exit from the chroot
exit


unmount -R /mnt


reboot




;;
[n]) echo $res;;
esac

