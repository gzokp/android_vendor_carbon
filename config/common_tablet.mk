# audio
include frameworks/base/data/sounds/NewAudio.mk

# common
$(call inherit-product, vendor/gzokp/config/common.mk)

# gps
#PRODUCT_COPY_FILES += \
#    vendor/gzokp/prebuilt/common/etc/gps.conf:system/etc/gps.conf

# media
#PRODUCT_COPY_FILES += \
#    vendor/gzokp/prebuilt/common/media/xhdpi/bootanimation.zip:system/media/bootanimation.zip

# ringtones
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Hydra.ogg \
    ro.config.notification_sound=Proxima.ogg \
    ro.config.alarm_alert=Cesium.ogg

