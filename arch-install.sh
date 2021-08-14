#!/bin/bash

echo "ArchLinux Semi-Automatic install script"

pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

lsblk
echo "Choose drive to partition (eg: sdX): "
read drive
cfdisk /dev/$drive

lsblk /dev/$drive
echo "Select partition to install ArchLinux (eg: sdX1,sdX2): "
read partition
mkfs.ext4 -L ArchLinux /dev/$partition

read -p "Create efi partition? [y/n] " answer

if [[ $answer = y ]]; then
  lsblk /dev/$drive
  echo "Choose EFI partition (eg: sdX1,sdX2): "
  read efipartition
  mkfs.fat -F32 /dev/$efipartition
fi

mount /dev/$partition /mnt
pacstrap /mnt base base-devel linux linux-firmware sudo vim
genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#chroot$/d' arch-install.sh > /mnt/arch-installc.sh
chmod +x /mnt/arch-installc.sh
cp packages.txt /mnt/packages.txt
arch-chroot /mnt ./arch-installc.sh
exit

#chroot
echo "Choose time zone (default: Indian/Maldives): "
read timezone
if [ -z "$timezone" ]; then
  ln -sf /usr/share/zoneinfo/Indian/Maldives /etc/localtime
else
  ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
fi
hwclock --systohc

read -p "Set English(us) as system language? [y/n] " language
if [[ $language = y ]]; then
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  echo "KEYMAP=us" > /etc/vconsole.conf
else
  vim locale.gen
  locale-gen
  echo "Select the language uncommented from locale.gen: "
  read lang
  echo "LANG=$lang" > /etc/locale.conf
fi

echo "Set Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts

mkinitcpio -P
echo "Set password for root user"
passwd


pacman --noconfirm -S grub efibootmgr os-prober networkmanager
lsblk
echo "Enter EFI partition (eg: sdX1,sdX2): "
read efipartition
mkdir /boot/efi
mount /dev/$efipartition /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux --removable
read -p "Enable grub os-prober? [y/n] :" probe
if [[ $probe = y ]]; then
  echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
fi
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

echo "Enter username: "
read username
useradd -m -G wheel -s /bin/bash $username
echo "Now you will be prompted to enter password for $username"
passwd $username
EDITOR=vim visudo
echo "Base installation finished"

read -p "Continue to restore configs from github.com/junaadh? [y/n]: " continue
if [[ $continue = n ]]; then
  exit
  rm /arch-installc.sh
fi

pacman -Sy - < ./packages.txt --needed --noconfirm
exit
rm /arch-installc.sh
