# config.mk
#
# Product-specific compile-time definitions.
#

TARGET_BOARD_PLATFORM := msm8916
TARGET_BOOTLOADER_BOARD_NAME := msm8916

BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true

#-include $(QCPATH)/common/msm8916/BoardConfigVendor.mk
include device/qcom/msm8916_64/BoardConfigVendor.mk

# bring-up overrides
BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false

MALLOC_IMPL := dlmalloc

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x02000000
#BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x02000000
#increase recovery size by berg
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x02400000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1288491008
#BOARD_USERDATAIMAGE_PARTITION_SIZE := 1860648960
#modify userdata size to 12.5G
BOARD_USERDATAIMAGE_PARTITION_SIZE := 13421772800
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := true

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := true
TARGET_NO_RPC := true

BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk

#put selinux in permissive for debug. berg 20150422
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

BOARD_KERNEL_SEPARATED_DT := true

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := true


# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_EGL_CFG := device/qcom/msm8916_64/egl.cfg
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
# Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES := true

TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
TARGET_INIT_VENDOR_LIB := libinit_msm

#add suffix variable to uniquely identify the board
TARGET_BOARD_SUFFIX := _64

TARGET_LDPRELOAD := libNimsWrap.so

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

#Enable SW based full disk encryption
TARGET_SWV8_DISK_ENCRYPTION := true

#####TWRP
TW_BERG_TWRP := true

#TARGET_PREBUILT_KERNEL := device/xiaomi/cancro/kernel
#TARGET_RECOVERY_FSTAB := device/xiaomi/cancro/recovery/twrp.fstab
#TARGET_RECOVERY_INITRC = device/qcom/msm8916_64/twrp/init.rc
#BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_23x41.h\"
#TARGET_RECOVERY_INITRC := device/xiaomi/cancro/recovery/init.rc


TW_OEM_BUILD := true
TW_USE_TOOLBOX :=true
TW_EXCLUDE_ENCRYPTED_BACKUPS := true
RECOVERY_SDCARD_ON_DATA := true


TW_CUSTOM_THEME := device/qcom/msm8916_64/recovery/twres
DEVICE_RESOLUTION := 1080x1920
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

#TW_TARGET_USES_QCOM_BSP := true

TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255


#TWRP_EVENT_LOGGING := false # enables touch event logging to help debug touchscreen issues (don't leave this on for a release - it will fill up your logfile very quickly)
#TW_NO_USB_STORAGE := true #-- removes the USB storage button on devices that don't support USB storage

#RECOVERY_GRAPHICS_USE_LINELENGTH := true # fixes slanty looking graphics on some devices
#BOARD_HAS_NO_REAL_SDCARD := false # -- disables things like sdcard partitioning and may save you some space if TWRP isn't fitting in your recovery patition
#TW_INCLUDE_DUMLOCK := false # includes HTC Dumlock for devices that need it
#TW_NO_BATT_PERCENT := false # disables the display of the battery percentage for devices that don't support it properly
#TW_CUSTOM_POWER_BUTTON := 107 -- custom maps the power button for the lockscreen
#TW_NO_REBOOT_BOOTLOADER := true -- removes the reboot bootloader button from the reboot menu
#TW_NO_REBOOT_RECOVERY := true -- removes the reboot recovery button from the reboot menu

#RECOVERY_TOUCHSCREEN_SWAP_XY := true -- swaps the mapping of touches between the X and Y axis
#RECOVERY_TOUCHSCREEN_FLIP_Y := true -- flips y axis touchscreen values
#RECOVERY_TOUCHSCREEN_FLIP_X := true -- flips x axis touchscreen values
#TW_ALWAYS_RMRF := true -- forces the rm -rf option to always be on (needed for some Motorola devices)
#TW_NEVER_UNMOUNT_SYSTEM := true -- never unmount system (needed for some Motorola devices)
#TW_INCLUDE_INJECTTWRP := true -- adds ability to inject TWRP into some Samsung boot images for Samsung devices that have recovery as a second ramdisk in the boot image
#TW_DEFAULT_EXTERNAL_STORAGE := true -- defaults to external storage instead of internal on dual storage devices (largely deprecated)

