
VGNAME="vc_vg"

[ -z $DSK_DEV ] && echo "Invalid Disk device defined" && exit 1

#Create a primary partition for about 200MB. Mark this as bootable.
#Create Linux LVM partition for the rest of the disk.
sfdisk -uM $DSK_DEV <<EOF
,200,L,*
,,8e
EOF

[ $? -ne 0 ] && echo "Partition creation failed" && exit 1

#Start LVM creations.

pvcreate "$DSK_DEV"2
[ $? -ne 0 ] && echo "pvcreate failed" && exit 1

vgcreate $VGNAME "$DSK_DEV"2
[ $? -ne 0 ] && echo "vgcreate failed" && exit 1

lvcreate -n vc_root -L 500M $VGNAME
[ $? -ne 0 ] && echo "root LVM creation failed" && exit 1

lvcreate -n vc_home -L 100M $VGNAME
[ $? -ne 0 ] && echo "home LVM creation failed" && exit 1

lvcreate -n vc_hroot -L 200M $VGNAME
[ $? -ne 0 ] && echo "hroot LVM creation failed" && exit 1

lvcreate -n vc_swap -L 200M $VGNAME
[ $? -ne 0 ] && echo "swap LVM creation failed" && exit 1

#Format all file systems.

#Format the boot partition in ext2.
mkfs.ext2 "$DSK_DEV"1
[ $? -ne 0 ] && echo "Ext3 format failed for 1" && exit 1

mkfs.ext3 /dev/$VGNAME/vc_root
[ $? -ne 0 ] && echo "vc_root format failed" && exit 1

mkfs.ext3 /dev/$VGNAME/vc_home
[ $? -ne 0 ] && echo "vc_home format failed" && exit 1

mkfs.ext3 /dev/$VGNAME/vc_hroot
[ $? -ne 0 ] && echo "vc_hroot format failed" && exit 1

mkswap /dev/$VGNAME/vc_swap
[ $? -ne 0 ] && echo "vc_swap format failed" && exit 1

#Mount and copy filesystems. and copy the directory tree.

mount /dev/$VGNAME/vc_root $destdir
[ $? -ne 0 ] && echo "/ mounting failed" && exit 1

cp -af $prepdir/* $destdir
[ $? -ne 0 ] && echo "cp failed" && exit 1

mount "$DSK_DEV"1 $destdir/boot
[ $? -ne 0 ] && echo "boot mounting failed" && exit 1

mount /dev/$VGNAME/vc_hroot $destdir/root
[ $? -ne 0 ] && echo "root mounting failed" && exit 1

mount /dev/$VGNAME/vc_home $destdir/home
[ $? -ne 0 ] && echo "home mounting failed" && exit 1

#Install grub.
grub-install --root-directory=$destdir "$DSK_DEV"1
[ $? -ne 0 ] && echo "Grub installed failed" && exit 1

#Copy a new device map file.
cp -f device.map.template $destdir/boot/grub/device.map
[ $? -ne 0 ] && echo "device.map copy failed" && exit 1

#Copy the grub.conf and menu.lst files.
cp -f grub.conf.template $destdir/boot/grub/grub.conf
[ $? -ne 0 ] && echo "grub.conf copy failed" && exit 1
pushd $destdir/boot/grub/
ln -s grub.conf menu.lst
[ $? -ne 0 ] && echo "linking failed" && exit 1
popd

#Create temporary fstab file entry.
echo "/dev/vc_vg/vc_root 	/       ext3    defaults   1 1" >>$tmp_fstab
echo "/dev/hda1             	/boot   ext2    defaults   1 2" >>$tmp_fstab
echo "/dev/vc_vg/vc_home 	/home   ext3    defaults   1 1" >>$tmp_fstab
echo "/dev/vc_vg/vc_hroot 	/root   ext3    defaults   1 1" >>$tmp_fstab
echo "/dev/vc_vg/vc_swap 	swap    swap    defaults   0 0" >>$tmp_fstab

exit 0
