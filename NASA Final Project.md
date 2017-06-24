NASA Final Project
===
[Ldap server](https://blog.gtwang.org/linux/ubuntu-ldap-server/)
[Ldap 頭城國小](http://blog.ilc.edu.tw/blog/blog/25793/trackbacks/530073)
[Ldap 入門](http://www.l-penguin.idv.tw/article/ldap-1.htm)
[Ldap 帳號管理](http://www.l-penguin.idv.tw/article/ldap-3.htm)
[Ldap Server Auth Arch linux](https://wiki.archlinux.org/index.php/LDAP_authentication)

`pacman -S make git htop gcc`
Install
`pacman -S openldap`

設定管理密碼
`slappasswd` 密碼 : nasa

# 工作站 

## 空間分配

| Partition | Type    | Size  | Note            |
| --------- | ------- | ----- | --------------- |
| sda1      | primary | 40 GB | ext4, for /     |
| sda2      | primary | 5 GB  | ext4, for /boot |
| sda3      | primary | 5 GB  | home            |

## 網路架構

NAT連外網 HOST ONLY 內網
DHCP 分配
`systemctl enable dhcpcd@enp0s3.service`
`systemctl enable dhcpcd@enp0s8.service`

# LDAP

## Configuration

### Set password

```shell
sed -i "/rootpw/ d" /etc/openldap/slapd.conf #find the line with rootpw and delete it
echo "rootpw    $(slappasswd)" >> /etc/openldap/slapd.conf  #add a line which includes the hashed password output from slappasswd
```



## **登入功能**

include 相關schema 在 slapd.conf
`include /etc/openldap/schema/nis.schema`



> `chown -R ldap:ldap /etc/openldap/slapd.d`
>
> 要在 systemctl start slapd 之前 (建database時)



> 6/9 照arch wiki改，可登入但是不沒有自動建立home



## Auth Server

[LDAP Auth](https://wiki.archlinux.org/index.php/LDAP_authentication)
**雷點一** : 要去掉 photo = =
**雷點二** : 要把第一個範例的 example.com 改成 example.org

# 安裝軟體清單
```
git clone https://pkgbuild.csie.ntu.edu.tw/git/wspkg.git
git clone https://pkgbuild.csie.ntu.edu.tw/git/wspkg-data.git
```
`pacman -S arch-install-scripts` 

設定環境變數
./build.sh 

## Trouble Shooting

````bash
[root@localhost wspkg-data]# ./build.sh wsarch.mk install

Running: make -f "wsarch.mk" WSPKGDIR="/root/wspkg" install

make: *** No rule to make target 'arch-install', needed by 'install'.  Stop.

Sorry... :(
````

> 功能尚未實作，目前為./build.sh wsarch.mk 產生檔案，之後再shellscript裝一波



## Conclusion

安裝的軟體大小為 20GB左右

Not hard

**Current File Location** : github hortune/NasaFinal

**Script Usage** : bash install.sh

# Archiso 
製造iso，目標是能自動安裝所有套件，跟啟動ansible配置好nfs和ldap。

## Install Archiso
```
pacman -S archiso
cp /usr/share/archiso/configs/releng/* -r archlive
```
