

set -o errexit
#set -v
#set -x

#ANDROID_BUILD_TOP="/disk01/work/work_berg/tmp/COSHIP_X1_5_0_FDH"
#ANDROID_PRODUCT_OUT="/disk01/work/work_berg/tmp/COSHIP_X1_5_0_FDH/out/target/product/msm8916_64"
#QCPATH="vendor/qcom/proprietary"

PRODUCT_OUT=out/target/product/msm8916_64
SOURCE_RECOVERY=bootable/recovery
TARGET_DEVICE_DIR=device/qcom/msm8916_64
TARGET_ROOT_OUT=$PRODUCT_OUT/root
TARGET_RECOVERY_OUT=$PRODUCT_OUT/recovery
TARGET_RECOVERY_ROOT_OUT=$PRODUCT_OUT/recovery/root

BOOT_SIGNER=boot_signer
MKBOOTFS=mkbootfs
MINIGZIP=minigzip
MKBOOTIMG=mkbootimg

SED_INPLACE="sed -i"
CL_GRN="\033[32m"
CL_RST="\033[0m"
PRT_IMG=$CL_GRN



INSTALLED_RECOVERYIMAGE_TARGET=$PRODUCT_OUT/recovery_twrp.img
INSTALLED_DEFAULT_PROP_TARGET=$PRODUCT_OUT/root/default.prop
INSTALLED_BUILD_PROP_TARGET=$PRODUCT_OUT/system/build.prop
RECOVERY_INSTALL_OTA_KEYS=$PRODUCT_OUT/obj/PACKAGING/ota_keys_intermediates/keys

#recovery_initrc=$SOURCE_RECOVERY/etc/init.rc
recovery_initrc=$TARGET_DEVICE_DIR/twrp/init.rc

recovery_fstab=$TARGET_DEVICE_DIR/recovery.fstab
recovery_sepolicy=$PRODUCT_OUT/system/etc/sepolicy.recovery
recovery_uncompressed_ramdisk=$PRODUCT_OUT/ramdisk-recovery.cpio
recovery_kernel=$PRODUCT_OUT/kernel
recovery_ramdisk=$PRODUCT_OUT/ramdisk-recovery.img
recovery_build_prop=$INSTALLED_BUILD_PROP_TARGET
recovery_binary=$PRODUCT_OUT/obj/EXECUTABLES/recovery_intermediates/recovery
recovery_resources_common=$SOURCE_RECOVERY/res-xxhdpi
recovery_font=$SOURCE_RECOVERY/fonts/18x32.png
boot_cmdline="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk"
boot_cmdline+=" androidboot.selinux=permissive"


cd $ANDROID_BUILD_TOP

#############################################
TARGET_RECOVERY_ROOT_TIMESTAMP=$TARGET_RECOVERY_OUT/root.ts
echo -e ${PRT_IMG}"----- Making recovery filesystem ------"${CL_RST}
mkdir -p $TARGET_RECOVERY_OUT
mkdir -p $TARGET_RECOVERY_ROOT_OUT/etc $TARGET_RECOVERY_ROOT_OUT/tmp
echo -e ${PRT_IMG}"Copying baseline ramdisk..."${CL_RST}
cp -R $TARGET_ROOT_OUT $TARGET_RECOVERY_OUT
echo -e ${PRT_IMG}"Modifying ramdisk contents..."${CL_RST}
rm -f $TARGET_RECOVERY_ROOT_OUT/init*.rc
cp -f $recovery_initrc $TARGET_RECOVERY_ROOT_OUT/
rm -f $TARGET_RECOVERY_ROOT_OUT/sepolicy
#cp -f out/target/product/msm8916_64/obj/ETC/sepolicy.recovery_intermediates/sepolicy.recovery out/target/product/msm8916_64/recovery/root/sepolicy
cp -f $recovery_sepolicy $TARGET_RECOVERY_ROOT_OUT/sepolicy
#-cp $TARGET_ROOT_OUT/init.recovery.*.rc $TARGET_RECOVERY_ROOT_OUT/
cp -f $recovery_binary $TARGET_RECOVERY_ROOT_OUT/sbin/

mkdir -p $TARGET_RECOVERY_ROOT_OUT/system/bin
mkdir -p $TARGET_RECOVERY_ROOT_OUT/res
#cp -rf bootable/recovery/res-xxhdpi/* out/target/product/msm8916_64/recovery/root/res
cp -rf $recovery_resources_common/* $TARGET_RECOVERY_ROOT_OUT/res
#cp -f bootable/recovery/fonts/18x32.png out/target/product/msm8916_64/recovery/root/res/images/font.png
cp -f $recovery_font $TARGET_RECOVERY_ROOT_OUT/res/images/font.png


##??$foreach item,$recovery_root_private, \
#	cp -rf $item $TARGET_RECOVERY_OUT/

#??$foreach item,$recovery_resources_private, \
#	cp -rf $item $TARGET_RECOVERY_ROOT_OUT/

#$foreach item,$recovery_fstab, \
#	  cp -f $item $TARGET_RECOVERY_ROOT_OUT/etc/recovery.fstab
#cp -f device/qcom/msm8916_64/recovery.fstab out/target/product/msm8916_64/recovery/root/etc/recovery.fstab
cp -f $recovery_fstab $TARGET_RECOVERY_ROOT_OUT/etc/recovery.fstab
cp -f $TARGET_DEVICE_DIR/twrp.fstab $TARGET_RECOVERY_ROOT_OUT/etc/twrp.fstab


#cp out/target/product/msm8916_64/obj/PACKAGING/ota_keys_intermediates/keys out/target/product/msm8916_64/recovery/root/res/keys
cp $RECOVERY_INSTALL_OTA_KEYS $TARGET_RECOVERY_ROOT_OUT/res/keys


#cat out/target/product/msm8916_64/root/default.prop out/target/product/msm8916_64/system/build.prop \
#out/target/product/msm8916_64/recovery/root/default.prop
cat $INSTALLED_DEFAULT_PROP_TARGET $recovery_build_prop > $TARGET_RECOVERY_ROOT_OUT/default.prop

$SED_INPLACE 's/ro.build.date.utc=.*/ro.build.date.utc=0/g' $TARGET_RECOVERY_ROOT_OUT/default.prop
$SED_INPLACE 's/ro.adb.secure=1/ro.adb.secure=0/g' $TARGET_RECOVERY_ROOT_OUT/default.prop
echo -e ${PRT_IMG}"----- Made recovery filesystem -------- $TARGET_RECOVERY_ROOT_OUT"${CL_RST}
touch $TARGET_RECOVERY_ROOT_TIMESTAMP


#add by berg
cp -f $TARGET_RECOVERY_ROOT_OUT/sbin/sh $TARGET_RECOVERY_ROOT_OUT/system/bin/
cp -f $TARGET_RECOVERY_ROOT_OUT/sbin/logcat $TARGET_RECOVERY_ROOT_OUT/system/bin/

###########################################
#out/host/linux-x86/bin/mkbootfs out/target/product/msm8916_64/recovery/root | out/host/linux-x86/bin/minigzip > out/target/product/msm8916_64/ramdisk-recovery.img
#out/host/linux-x86/bin/mkbootimg  --kernel out/target/product/msm8916_64/kernel  --ramdisk out/target/product/msm8916_64/ramdisk-recovery.img --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk" --base 0x80000000 --pagesize 2048 --dt out/target/product/msm8916_64/dt.img  --output out/target/product/msm8916_64/recovery.img

echo -e ${PRT_IMG}"----- Making uncompressed recovery ramdisk ------"${CL_RST}
$MKBOOTFS $TARGET_RECOVERY_ROOT_OUT > $recovery_uncompressed_ramdisk

echo -e ${PRT_IMG}"----- Making recovery ramdisk ------"${CL_RST}
$MINIGZIP < $recovery_uncompressed_ramdisk > $recovery_ramdisk

##$MKBOOTIMG $INTERNAL_RECOVERYIMAGE_ARGS $BOARD_MKBOOTIMG_ARGS --output $INSTALLED_RECOVERYIMAGE_TARGET
echo -e ${PRT_IMG}"----- Making recovery image ------"${CL_RST}
$MKBOOTIMG --kernel $recovery_kernel --ramdisk $recovery_ramdisk --cmdline "$boot_cmdline" --base 0x80000000 --pagesize 2048 --dt $PRODUCT_OUT/dt.img --output $INSTALLED_RECOVERYIMAGE_TARGET




#${call assert-max-image-size,$@,${BOARD_RECOVERYIMAGE_PARTITION_SIZE
echo -e ${PRT_IMG}"----- Made recovery image: $INSTALLED_RECOVERYIMAGE_TARGET --------"${CL_RST}


#############################################
#ifeq {true,${PRODUCTS.${INTERNAL_PRODUCT.PRODUCT_SUPPORTS_VERITY
#out/host/linux-x86/bin/boot_signer /recovery out/target/product/msm8916_64/recovery.img build/target/product/security/verity_private_dev_key out/target/product/msm8916_64/recovery.img
#${BOOT_SIGNER /recovery $@ ${PRODUCTS.$INTERNAL_PRODUCT.PRODUCT_VERITY_SIGNING_KEY $@
#endif
