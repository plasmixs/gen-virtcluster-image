#Copy the fstab file first.

cp -f fstab.template $destdir/etc/fstab 

#Check if the dsk_prepare file has created 
#temporary file containg the fs details.
[ -f $tmp_fstab ] && cat $tmp_fstab >> $destdir/etc/fstab 

rm -f $tmp_fstab

exit 0 
