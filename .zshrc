#!/bin/bash

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
systemctl enable dhcpcd@enp0s3
systemctl enable dhcpcd@enp0s8
systemctl start dhcpcd@enp0s3
systemctl start dhcpcd@enp0s8
pacman -S vim openssh git --noconfirm
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
systemctl enable sshd
systemctl start sshd
pacman -S nfs-utils --noconfirm
systemctl enable rpcbind.service
systemctl enable nfs-client.target
systemctl enable remote-fs.target
systemctl start rpcbind.service
systemctl start nfs-client.target
systemctl start remote-fs.target
/etc/hosts
echo "192.168.99.50 localhost.localdomain nfs_server" >> /etc/hosts
echo -e "\n#$(grep /home /etc/fstab)" >> /etc/fstab
a=$(grep /home /etc/fstab -n | sed 1q | cut -c 1)
sed '8d' /etc/fstab > temp
cat temp > /etc/fstab
rm temp
echo "nfs_server:/music    /home     nfs    rsize=8192,wsize=8192,timeo=14,_netdev    0    0" >> /etc/fstab
systemctl restart rpcbind.service
systemctl restart nfs-client.target
systemctl restart remote-fs.target
pacman -S openldap --noconfirm
pacman -S nss-pam-ldapd --noconfirm
git clone https://github.com/skyDaniel/ldap_client.git
cp ldap_client/ldap.conf /etc/openldap/ldap.conf
cp ldap_client/nsswitch.conf /etc/nsswitch.conf
cp ldap_client/nslcd.conf /etc/nslcd.conf
systemctl enable nslcd
systemctl start nslcd
cp ldap_client/system-auth /etc/pam.d/system-auth
cp ldap_client/su /etc/pam.d/su
cp ldap_client/su-l /etc/pam.d/su-l
cp ldap_client/passwd /etc/pam.d/passwd
cp ldap_client/system-login /etc/pam.d/system-login
cp ldap_client/sudo /etc/pam.d/sudo
cd ldap_client
bash install.sh
cd ..
rm -rf ldap_client
exit
" | arch-chroot /mnt
poweroff
