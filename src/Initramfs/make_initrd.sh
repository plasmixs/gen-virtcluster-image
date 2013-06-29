#!/bin/bash

chmod +x img_mnt/init

# Finish up...
pushd img_mnt
find . | cpio --quiet -H newc -o | gzip -9 -n > ramdisk.img.gz
popd
mv img_mnt/ramdisk.img.gz ramdisk.img
#rm -rf ./img_mnt
echo "Done"
