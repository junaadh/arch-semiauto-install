#!/bin/bash

echo "ArchLinux Semi-Automatic install script"

pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

lsblk
echo "Choose drive to partition: "
read drive
cfdisk $drive

lsblk $drive
echo "Select partition to install ArchLinux: "
read /partition
mkfs.ext4 -L ArchLinux $partition

read -p "Create efi partition? [y/n] " answer

if [[ $answer = y ]]; then
  lsblk $drive
  echo "Choose EFI partition: "
  read efipartition
  mkfs.vfat -F32 $efipartition
fi

mount $partition /mnt
pacstrap /mnt base base-devel linux linux-firmware sudo vim
genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#chroot$/d' arch-install.sh > /mnt/arch-installc.sh
arch-chroot /mnt ./arch-installc.sh
exit

#chroot
echo "Choose time zone: "
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

echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts

mkinitcpio -P
passwd

pacman --noconfirm -S grub efibootmgr os-prober networkmanager
echo "Enter EFI partition: "
read efipartition
mkdir /boot/efi
mount $efipartition /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux --removable
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
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
  su $username
  cd $HOME
  mkdir {Documents,Downloads,Pictures,Music,Scripts}
  exit
  rm /arch-installc.sh
fi

pacman -Sy - < ./packages.txt
su $username
cd $HOME
mkdir {Documents,Downloads,Pictures,Music,Scripts}
rm -rf .config
git clone git@github.com:junaadh/.config.git
mkdir -p .cache/
cd .cache
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
yay -S google-chrome-stable polybar
exit
rm /arch-installc.sh

