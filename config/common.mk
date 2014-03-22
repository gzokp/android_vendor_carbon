# brand
PRODUCT_BRAND ?= GZOKP

# SuperUser
SUPERUSER_EMBEDDED := true

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/gzokp/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_BOOTANIMATION := vendor/gzokp/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    persist.sys.root_access=3

# selinux dialog
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# camera shutter sound property
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.camera-sound=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

# main packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    Camera \
    Development \
    CMFileManager \
    Galaxy4 \
    LatinIME \
    LiveWallpapers \
    LiveWallpapersPicker \
    LockClock \
    NoiseField \
    PhaseBeam \
    PhotoTable \
    Superuser \
    su \
    Torch \
    VoicePlus \
    libemoji

# gzokp packages
PRODUCT_PACKAGES += \
    BlueBalls \
    ROMStats \
    Wallpapers

# dsp manager
PRODUCT_PACKAGES += \
    DSPManager \
    audio_effects.conf \
    libcyanogen-dsp

# Screen recorder
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

PRODUCT_PACKAGES += \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    nano \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# languages
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# themes
include vendor/gzokp/config/theme_chooser.mk

# korean
$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)

# overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/gzokp/overlay/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/gzokp/overlay/common

# bin
PRODUCT_COPY_FILES += \
    vendor/gzokp/prebuilt/common/bin/sysinit:system/bin/sysinit

# etc
PRODUCT_COPY_FILES += \
    vendor/gzokp/prebuilt/common/etc/init.gzokp.rc:root/init.gzokp.rc

# prebuilt
PRODUCT_COPY_FILES += \
    vendor/gzokp/prebuilt/common/xbin/sysro:system/xbin/sysro \
    vendor/gzokp/prebuilt/common/xbin/sysrw:system/xbin/sysrw \
    vendor/gzokp/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/gzokp/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Backup tool
GZOKP_BUILD = true
PRODUCT_COPY_FILES += \
    vendor/gzokp/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/gzokp/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/gzokp/prebuilt/common/bin/50-gzokp.sh:system/addon.d/50-gzokp.sh \
    vendor/gzokp/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/gzokp/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/gzokp/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/gzokp/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# sip/voip
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# nfc
PRODUCT_COPY_FILES += \
    vendor/gzokp/config/permissions/com.gzokp.android.xml:system/etc/permissions/com.gzokp.android.xml \
    vendor/gzokp/config/permissions/com.gzokp.nfc.enhanced.xml:system/etc/permissions/com.gzokp.nfc.enhanced.xml

# version
RELEASE = false
GZOKP_VERSION_MAJOR = 2
GZOKP_VERSION_MINOR = 0

# Set GZOKP_BUILDTYPE
ifdef GZOKP_NIGHTLY
    GZOKP_BUILDTYPE := NIGHTLY
endif
ifdef GZOKP_EXPERIMENTAL
    GZOKP_BUILDTYPE := EXPERIMENTAL
endif
ifdef GZOKP_RELEASE
    GZOKP_BUILDTYPE := RELEASE
endif
# Set Unofficial if no buildtype set (Buildtype should ONLY be set by GZOKP Devs!)
ifdef GZOKP_BUILDTYPE
else
    GZOKP_BUILDTYPE := UNOFFICIAL
    GZOKP_VERSION_MAJOR :=
    GZOKP_VERSION_MINOR :=
endif

# Set GZOKP version
ifdef GZOKP_RELEASE
    GZOKP_VERSION := "GZOKP-KK-v"$(GZOKP_VERSION_MAJOR).$(GZOKP_VERSION_MINOR)
else
    GZOKP_VERSION := "GZOKP-KK-$(GZOKP_BUILDTYPE)"-$(shell date +%Y%m%d-%H%M)
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.gzokp.version=$(GZOKP_VERSION)

# ROM Statistics and ROM Identification
PRODUCT_PROPERTY_OVERRIDES += \
ro.romstats.askfirst=1 \
ro.romstats.ga=UA-43747246-1 \
ro.romstats.name=GZOKP- \
ro.romstats.url=http://stats.gzokp-rom.com \
ro.romstats.version=$(GZOKP_VERSION)
