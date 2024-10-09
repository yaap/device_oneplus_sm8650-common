#
# Copyright (C) 2021-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Add common definitions for Qualcomm
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# ANT+
PRODUCT_PACKAGES += \
    AntHalService-Soong \
    com.dsi.ant@1.0.vendor

# Alert slider
PRODUCT_PACKAGES += \
    KeyHandler \
    tri-state-key-calibrate

# Audio
SOONG_CONFIG_NAMESPACES += android_hardware_audio
SOONG_CONFIG_android_hardware_audio += \
    run_64bit
SOONG_CONFIG_android_hardware_audio_run_64bit := true

PRODUCT_PACKAGES += \
    android.hardware.audio@7.1-impl \
    android.hardware.audio.common-V1-ndk.vendor \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service \
    android.hardware.bluetooth.audio-impl \
    android.hardware.soundtrigger@2.3-impl \
    audio.bluetooth.default \
    audio.primary.pineapple \
    audio.r_submix.default \
    audio.usb.default \
    audioadsprpcd \
    libagmmixer \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libbatterylistener \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libsndcardparser \
    libtinycompress \
    libvolumelistener \
    sound_trigger.primary.pineapple

AUDIO_HAL_DIR := hardware/qcom-caf/sm8650/audio/primary-hal
AUDIO_PAL_DIR := hardware/qcom-caf/sm8650/audio/pal

PRODUCT_COPY_FILES += \
    $(AUDIO_HAL_DIR)/configs/common/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(AUDIO_HAL_DIR)/configs/pineapple/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_pineapple/audio_effects.conf \
    $(AUDIO_HAL_DIR)/configs/pineapple/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_pineapple/audio_effects.xml \
    $(AUDIO_HAL_DIR)/configs/pineapple/microphone_characteristics.xml:$(TARGET_COPY_OUT_VENDOR)/etc/microphone_characteristics.xml \
    $(AUDIO_PAL_DIR)/configs/pineapple/Hapticsconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/Hapticsconfig.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Authsecret
PRODUCT_PACKAGES += \
    android.hardware.authsecret@1.0.vendor

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1.vendor \
    android.hardware.bluetooth.audio-V3-ndk.vendor \
    vendor.qti.hardware.bluetooth.audio-V1-ndk.vendor \
    vendor.qti.hardware.bluetooth_audio@2.1.vendor \
    vendor.qti.hardware.btconfigstore@1.0.vendor \
    vendor.qti.hardware.btconfigstore@2.0.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# Blur
TARGET_ENABLE_BLUR := true

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-V1-ndk.vendor \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

# Camera
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk.vendor \
    android.hardware.camera.common-V1-ndk.vendor \
    android.hardware.camera.device-V2-ndk.vendor \
    android.hardware.camera.metadata-V2-ndk.vendor \
    android.hardware.camera.provider-V2-ndk.vendor \
    libcamera_metadata.vendor \
    libexif.vendor \
    libutilscallstack.vendor \
    libyuv.vendor \
    vendor.qti.hardware.camera.postproc@1.0.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Configstore
PRODUCT_PACKAGES += \
    vendor.qti.hardware.capabilityconfigstore@1.0.vendor

# Context Hub
PRODUCT_PACKAGES += \
    android.hardware.contexthub-V2-ndk.vendor

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# DebugFS
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor \
    android.hardware.graphics.composer3-V2-ndk.vendor \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    init.qti.display_boot.rc \
    init.qti.display_boot.sh \
    libdisplayconfig.qti \
    libdisplayconfig.system.qti \
    libqdMetaData \
    libqdMetaData.system \
    libsdmcore \
    libsdmutils \
    libui.vendor \
    vendor.display.config@1.0 \
    vendor.display.config@1.11.vendor \
    vendor.display.config@2.0 \
    vendor.display.config@2.0.vendor \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.allocator@1.0.vendor \
    vendor.qti.hardware.display.allocator@3.0.vendor \
    vendor.qti.hardware.display.allocator@4.0.vendor \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.composer3-V1-ndk \
    vendor.qti.hardware.display.config-V1-ndk.vendor \
    vendor.qti.hardware.display.config-V2-ndk.vendor \
    vendor.qti.hardware.display.config-V3-ndk.vendor \
    vendor.qti.hardware.display.config-V4-ndk.vendor \
    vendor.qti.hardware.display.config-V5-ndk \
    vendor.qti.hardware.display.config-V5-ndk.vendor \
    vendor.qti.hardware.display.config-V6-ndk.vendor \
    vendor.qti.hardware.display.config-V7-ndk.vendor \
    vendor.qti.hardware.display.config-V8-ndk.vendor \
    vendor.qti.hardware.display.config-V9-ndk.vendor \
    vendor.qti.hardware.display.config-V10-ndk.vendor \
    vendor.qti.hardware.display.demura-service \
    vendor.qti.hardware.display.demura-V1-ndk \
    vendor.qti.hardware.display.mapper@1.1.vendor \
    vendor.qti.hardware.display.mapper@2.0.vendor \
    vendor.qti.hardware.display.mapper@3.0.vendor \
    vendor.qti.hardware.display.mapper@4.0.vendor \
    vendor.qti.hardware.display.postproc-V1-ndk.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# DisplayConfig
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display_id_4630946450791512195.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4630946450791512195.xml

# Doze
PRODUCT_PACKAGES += \
    OplusDoze

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-V1-ndk.vendor \
    android.hardware.drm-service.clearkey

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.oplus \
    android.hardware.biometrics.fingerprint-V3-ndk.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper-V1-ndk.vendor \
    android.hardware.gatekeeper@1.0.vendor \
    libgatekeeper.vendor

# GPS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps.conf:$(TARGET_COPY_OUT_ODM)/etc/gps.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

PRODUCT_PACKAGES += \
    android.hardware.gnss-V3-ndk.vendor

# Graphics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery \
    android.hardware.health-V1-ndk.vendor \
    android.hardware.health-V2-ndk.vendor \
    android.hardware.health@1.0.vendor \
    android.hardware.health@2.1.vendor

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport.vendor \
    libhwbinder.vendor

# Hotword enrollment
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# IPACM
PRODUCT_PACKAGES += \
    ipacm \
    IPACM_cfg.xml \
    IPACM_Filter_cfg.xml

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

PRODUCT_PACKAGES += \
    fstab.qcom \
    init.class_main.sh \
    init.oplus.rc \
    init.qcom.early_boot.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.recovery.rc \
    init.qcom.sh \
    init.target.rc \
    ueventd.oplus.rc \
    ueventd.qcom.rc

# IR Blaster
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.consumerir.xml

# Identity
PRODUCT_PACKAGES += \
    android.hardware.identity-V5-ndk.vendor

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore.xml \
    android.hardware.keymaster-V3-ndk.vendor \
    android.hardware.keymaster@4.1.vendor \
    libkeymaster_messages.vendor

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-V1-ndk.vendor \
    android.hardware.security.keymint-V2-ndk.vendor \
    android.hardware.security.keymint-V3-ndk.vendor \
    android.hardware.security.rkp-V3-ndk.vendor \
    android.hardware.security.secureclock-V1-ndk.vendor \
    android.hardware.security.sharedsecret-V1-ndk.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Media
PRODUCT_COPY_FILES += \
    $(AUDIO_HAL_DIR)/configs/common/codec2/media_codecs_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2_audio.xml \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.base-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.base-arm64.policy \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.ext-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy

PRODUCT_PACKAGES += \
    android.hardware.media.bufferpool2-V1-ndk.vendor \
    libavservices_minijail \
    libavservices_minijail.vendor \
    libcodec2_hidl@1.2.vendor \
    libcodec2_vndk.vendor \
    libpalclient

# Memtrack
PRODUCT_PACKAGES += \
    vendor.qti.hardware.memtrack-service

# Net
PRODUCT_PACKAGES += \
    android.system.net.netd-V1-ndk.vendor

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    android.hardware.secure_element-V1-ndk.vendor \
    android.hardware.secure_element@1.0.vendor \
    com.android.nfc_extras \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

# OSENSE
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.osense.client-service

# Oplus-fwk
$(call inherit-product, hardware/oplus/oplus-fwk/oplus-fwk.mk)

# Overlays
$(call inherit-product, hardware/oplus/overlay/generic/generic.mk)
$(call inherit-product, hardware/oplus/overlay/qssi/qssi.mk)

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-yaap

PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    CarrierConfigResCommon \
    FrameworksResTarget \
    OPlusFrameworksResCommon \
    OPlusSettingsResCommon \
    OPlusSystemUIResCommon \
    WifiResTarget

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.2.vendor \
    android.hardware.power-service.lineage-libperfmgr \
    libqti-perfd-client

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# PowerShare
PRODUCT_PACKAGES += \
    vendor.lineage.powershare@1.0-service.oplus

# Protobuf
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat

# QCOM
TARGET_BOARD_PLATFORM := pineapple

# QMI
PRODUCT_PACKAGES += \
    libcurl.vendor \
    libjson \
    libjsoncpp.vendor \
    libqti_vndfwk_detect.vendor \
    libqti_vndfwk_detect_vendor \
    libsqlite.vendor \
    libvndfwk_detect_jni.qti.vendor \
    libvndfwk_detect_jni.qti_vendor

# RIL
PRODUCT_PACKAGES += \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config-V2-ndk.vendor \
    android.hardware.radio-V2-ndk.vendor \
    android.hardware.radio.config-V2-ndk.vendor \
    android.hardware.radio.data-V2-ndk.vendor \
    android.hardware.radio.messaging-V2-ndk.vendor \
    android.hardware.radio.modem-V2-ndk.vendor \
    android.hardware.radio.network-V2-ndk.vendor \
    android.hardware.radio.sap-V1-ndk.vendor \
    android.hardware.radio.sim-V2-ndk.vendor \
    android.hardware.radio.voice-V2-ndk.vendor \
    librmnetctl

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice-V1-ndk.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.sensors-V2-ndk.vendor \
    android.hardware.sensors-service.oplus-multihal \
    libsensorndkbridge \
    sensors.dynamic_sensor_hal \
    sensors.oplus

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# Shims
PRODUCT_PACKAGES += \
    libshim_ui \
    libcodec2_shim \
    libhidlbase_shim

# Shipping API
BOARD_SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL := $(BOARD_SHIPPING_API_LEVEL)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/oplus \
    hardware/qcom-caf/common/libqti-perfd-client \
    kernel/oneplus/sm8650 \
    kernel/oneplus/sm8650-modules

# Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Task Profiles
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \
    system/core/libprocessgroup/profiles/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json

# Telephony
PRODUCT_PACKAGES += \
    OplusEuicc \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml \
    telephony-ext

ifneq ($(TARGET_BUILD_GAPPS),true)
PRODUCT_PACKAGES += \
    OpenEUICC
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti \
    android.hardware.thermal-V1-ndk.vendor \
    android.hardware.thermal@2.0.vendor

# Trusted User Interface
PRODUCT_PACKAGES += \
    android.hidl.memory.block@1.0.vendor \
    vendor.qti.hardware.systemhelper@1.0.vendor

# Virtualization service
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.qti \
    android.hardware.usb.gadget-service.qti \
    libusbhost.vendor

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/usb/usb_compositions.conf:$(TARGET_COPY_OUT_ODM)/etc/usb_compositions.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_PACKAGES += \
    init.qcom.usb.rc \
    init.qcom.usb.sh

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Vendor libstdc++
PRODUCT_PACKAGES += \
    libstdc++_vendor

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
#PRODUCT_PACKAGES += \
#    vendor.qti.hardware.vibrator.service.oplus

#PRODUCT_COPY_FILES += \
#    vendor/qcom/opensource/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    android.hardware.wifi.supplicant-V1-ndk.vendor \
    android.hardware.wifi.supplicant-V2-ndk.vendor \
    android.hardware.wifi-V1-ndk.vendor \
    android.hardware.wifi.hostapd-V1-ndk.vendor \
    hostapd \
    libwpa_client \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

# WiFi firmware symlinks
PRODUCT_PACKAGES += \
    firmware_wlanmdsp.otaupdate_symlink \
    firmware_wlan_mac.bin_symlink \
    firmware_WCNSS_qcom_cfg.ini_symlink

# WiFi Display
PRODUCT_PACKAGES += \
    android.media.audio.common.types-V3-cpp \
    libnl \
    libpng.vendor \
    libwfdaac_vendor

PRODUCT_BOOT_JARS += \
    WfdCommon

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/oneplus/sm8650-common/sm8650-common-vendor.mk)
