#!/usr/bin/env bash

sudo su
apt-get install vsftpd libpam-pwdfile apache2-utils
mv /etc/vsftpd.conf /etc/vsftpd.conf.bak
echo -e -n "Введіть шлях до FTP папки до якої користувачі матимуть доступ:\n"
read local_root
echo -e -n "listen=YES\nanonymous_enable=NO\nlocal_enable=YES\nwrite_enable=YES\nlocal_umask=022\nnopriv_user=vsftpd\nvirtual_use_local_privs=YES\nguest_enable=YES\nuser_sub_token=\$USER\nlocal_root=$local_root\nchroot_local_user=YES\nhide_ids=YES\nguest_username=vsftpd" > /etc/vsftpd.conf
mkdir /etc/vsftpd
echo -e -n "Введіть логін першого користувача:\n"
read ftp_login
htpasswd -cd /etc/vsftpd/ftpd.passwd $ftp_login
echo -e -n "Для створення новик користувачів введіть 'sudo htpasswd -d /etc/vsftpd/ftpd.passwd <<логін>>'\n"
mv /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bak
echo -e -n 'auth required pam_pwdfile.so pwdfile /etc/vsftpd/ftpd.passwd\naccount required pam_permit.so' > /etc/pam.d/vsftpd
useradd --home /home/vsftpd --gid nogroup -m --shell /bin/false vsftpd
mkdir $local_root
chmod -R 755 $local_root
chown -R vsftpd:nogroup $local_root
systemctl enable vsftpd
systemctl start vsftpd
