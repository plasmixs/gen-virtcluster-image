prepdir=$PWD/img_mnt

#Initially create the directory.
mkdir -p $prepdir

#Generic devices files.
mkdir -p $prepdir/dev
mknod -m 666 $prepdir/dev/null c 1 3
mknod -m 666 $prepdir/dev/zero c 1 5
mknod -m 600 $prepdir/dev/console c 5 1

chown root:root $prepdir/dev/null $prepdir/dev/zero $prepdir/dev/console

mkdir -p $prepdir/etc
touch $prepdir/etc/mtab

#For yum
mkdir -p $prepdir/var/log
touch $prepdir/var/log/yum.log
mkdir -p $prepdir/var/lib/yum

#Install & resolve dependencies using yum
yum -vy --installroot=$prepdir --disablerepo=* --enablerepo="InstallMedia" install coreutils lvm2 mount udev modutils 
retVal=$?

exit $retVal 
