echo "n
p


+40G
n
p


+5G
a
2
n
p


+5G
p
w" | fdisk /dev/sda
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
mkdir /mnt/boot
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt/boot
mkdir /mnt/home
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt/home
pacstrap /mnt base
genfstab -p -U /mnt > /mnt/etc/fstab
echo "echo "Y" | pacman -S grub-bios
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
echo "root:root" | chpasswd
exit
" | arch-chroot /mnt
poweroff
