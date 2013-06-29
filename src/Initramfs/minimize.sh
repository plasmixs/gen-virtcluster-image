prepdir=$PWD/img_mnt

rm -rf $prepdir/usr/lib/locale
rm -rf $prepdir/usr/share/locale
rm -rf $prepdir/usr/lib/gconv
rm -rf $prepdir/usr/lib64/gconv
rm -f $prepdir/usr/bin/localedef
rm -f $prepdir/usr/$prepdir/sbin/build-locale-archive

rm -rf $prepdir/usr/share/man
rm -rf $prepdir/usr/share/doc
rm -rf $prepdir/usr/share/info
rm -rf $prepdir/usr/share/gnome/help

rm -rf $prepdir/usr/share/cracklib

rm -rf $prepdir/usr/share/i18n

rm -rf $prepdir/var/lib/rpm
rm -rf $prepdir/var/lib/yum

rm -rf $prepdir/var/cache/yum

rm -f $prepdir/sbin/sln
rm -f $prepdir/sbin/ldconfig
rm -f $prepdir/etc/ld.so.cache
rm -rf $prepdir/var/cache/ldconfig
mkdir -p $prepdir/var/cache/ldconfig


cp $prepdir/usr/share/zoneinfo/UTC UTC
rm -rf $prepdir/usr/share/zoneinfo
mkdir -p --mode=0755 $prepdir/usr/share/zoneinfo
mv UTC $prepdir/usr/share/zoneinfo/UTC


cat > $prepdir/etc/services <<'__EOF__'
tcpmux 1/tcp
tcpmux 1/udp
echo 7/tcp
echo 7/udp
discard 9/tcp sink null
discard 9/udp sink null
ftp 21/tcp
ftp 21/udp fsp fspd
ssh 22/tcp
ssh 22/udp
telnet 23/tcp
telnet 23/udp
smtp 25/tcp mail
smtp 25/udp mail
time 37/tcp timserver
time 37/udp timserver
nameserver 42/tcp name
nameserver 42/udp name
domain 53/tcp
domain 53/udp
bootps 67/tcp
bootps 67/udp
bootpc 68/tcp dhcpc
bootpc 68/udp dhcpc
tftp 69/tcp
tftp 69/udp
finger 79/tcp
finger 79/udp
http 80/tcp www www-http
http 80/udp www www-http
http 80/sctp
kerberos 88/tcp kerberos5 krb5
kerberos 88/udp kerberos5 krb5
pop3 110/tcp pop-3
pop3 110/udp pop-3
sunrpc 111/tcp portmapper rpcbind
sunrpc 111/udp portmapper rpcbind
auth 113/tcp authentication tap ident
auth 113/udp authentication tap ident
ntp 123/tcp
ntp 123/udp
imap 143/tcp imap2
imap 143/udp imap2
snmp 161/tcp
snmp 161/udp
snmptrap 162/tcp
snmptrap 162/udp snmp-trap
__EOF__
