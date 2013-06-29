#!/bin/sh

export WORK_DIR=$PWD
LOG=$WORK_DIR/exec.log
SH_DIR=$WORK_DIR/scripts

echo "Starting @ $(date)" >$LOG

source $WORK_DIR/conf

#Install packages using yum.
if [ "$YUM_PREP" = "y" ]
then
	echo "Preparing yum to install packages"
	sh $SH_DIR/yum_prepare.sh 1>>$LOG 2>&1
	[ $? -ne 0 ] && echo "Yum installation failed" && exit 1
	echo "Packages installed successfully"
fi

#Run disk preparation scripts to create partitions and install root dir.
if [ "$DSK_PREP" = "y" ]
then
	echo "Preparing disk"
	sh $SH_DIR/dsk_prep.sh 1>>$LOG 2>&1
	[ $? -ne 0 ] && echo "Disk preparation failed" && exit 1
	echo "Disk ready for usage"
fi

#Copy and update fstab.
if [ "$FSTAB_PROC" = "y" ]
then
	echo "Preparing fstab"
	sh $SH_DIR/fstab.sh 1>>$LOG 2>&1
	[ $? -ne 0 ] && echo "fstab preparation failed" && exit 1
	echo "Fstab done."
fi
