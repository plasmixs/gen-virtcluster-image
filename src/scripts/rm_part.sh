destdir="/mnt"
VGNAME="vc_vg"
DSK_DEV="/dev/sdc"

umount $destdir/boot
umount $destdir/root
umount $destdir/home
umount $destdir

lvremove -f $VGNAME 
vgremove $VGNAME
pvremove -f "$DSK_DEV"2 
