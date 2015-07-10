
PRODUCT_OUT=$OUT
cd $ANDROID_BUILD_TOP

cp -f $OUT/recovery/root/sbin/sh $OUT/recovery/root/system/bin/
cp -f $OUT/recovery/root/sbin/logcat $OUT/recovery/root/system/bin/


mkbootfs $PRODUCT_OUT/recovery/root | minigzip > $PRODUCT_OUT/ramdisk-recovery.img
mkbootimg  --kernel $PRODUCT_OUT/kernel \
		--ramdisk $PRODUCT_OUT/ramdisk-recovery.img \
		--cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk  androidboot.selinux=permissive" \
		--base 0x80000000 --pagesize 2048 --dt $PRODUCT_OUT/dt.img \
		--output $PRODUCT_OUT/recovery.img
