# Copyright (C) 2021 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# Alert Slider
PRODUCT_PACKAGES += \
    TriStateHandler \
    tri-state-key_daemon

# Attestation
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Audio
PRODUCT_PACKAGES += \
    audio_amplifier.lahaina

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.vc_call_vol_steps=9 \
    ro.vendor.audio.sdk.fluencetype=fluence \
    persist.vendor.audio_hal.dsp_bit_width_enforce_mode=24 \
    persist.vendor.audio.bcl.enabled=false \
    persist.vendor.audio.fluence.voicerec=true \
    persist.vendor.audio.speaker.prot.enable=false \
    persist.vendor.audio.spv4.enable=false \
    persist.vendor.audio.vbat.enabled=false \
    vendor.audio.feature.spkr_prot.enable=false \
    vendor.audio.hal.output.suspend.supported=false

# Authsecret
PRODUCT_PACKAGES += \
    android.hardware.authsecret@1.0.vendor

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0 \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth.audio@2.0-impl \
    audio.bluetooth.default \
    com.dsi.ant@1.0.vendor \
    com.qualcomm.qti.bluetooth_audio@1.0.vendor \
    libbluetooth_audio_session \
    vendor.qti.hardware.bluetooth_audio@2.1.vendor \
    vendor.qti.hardware.btconfigstore@1.0.vendor \
    vendor.qti.hardware.btconfigstore@2.0.vendor

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.fflag.override.settings_bluetooth_hearing_aid=true \
    persist.vendor.qcom.bluetooth.a2dp_mcast_test.enabled=false \
    persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2 \
    persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true \
    persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true \
    persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=true \
    persist.vendor.qcom.bluetooth.scram.enabled=false \
    persist.vendor.qcom.bluetooth.twsp_state.enabled=false \
    vendor.hw.fm.init=0

# Boot
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti \
    android.hardware.boot@1.1-impl-qti.recovery \
    android.hardware.boot@1.1-service

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service_64 \
    libcamera2ndk_vendor \
    libstdc++.vendor \
    vendor.qti.hardware.camera.postproc@1.0.vendor

# Charging
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.charger.enable_suspend=1

# Config Store
PRODUCT_PACKAGES += \
    disable_configstore

# DPM
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.dpm.idletimer.mode=default \
    persist.vendor.dpmhalservice.enable=1

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4.vendor \
    android.hardware.drm@1.4-service.clearkey

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V1-ndk_platform \
    android.hardware.graphics.common-V1-ndk_platform.vendor \
    vendor.oneplus.hardware.display@1.0.vendor

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.sf.native_mode=2 \
    ro.vendor.display.sensortype=2 \
    vendor.display.disable_mask_layer_hint=1 \
    vendor.display.use_layer_ext=1

# Doze
PRODUCT_PACKAGES += \
    ParanoidDoze

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.sensor.pickup=oneplus.sensor.op_motion_detect

# FRP
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/bootdevice/by-name/frp

# Fastboot
PRODUCT_PACKAGES += \
    fastbootd

# GPS
LOC_HIDL_VERSION = 4.0

# GSI
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0 \
    android.hardware.gatekeeper@1.0.vendor


PRODUCT_PROPERTY_OVERRIDES += \
    vendor.gatekeeper.disable_spu=true

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl-qti \
    android.hardware.health@2.1-service

# IMS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1 \
    persist.dbg.wfc_avail_ovr=1

# Incremental FS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=yes

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default

PRODUCT_PACKAGES += \
    fstab.default \
    init.oneplus.camera.rc \
    init.oneplus.display.rc \
    init.oneplus.fingerprint.rc \
    init.oneplus.haptics.rc \
    init.oneplus.overlay.rc \
    init.oneplus.perf.rc \
    init.oneplus.power.rc \
    init.oneplus.telephony.rc \
    init.qti.ufs.rc \
    init.target.rc \
    ueventd.lahaina.rc \
    ueventd.oneplus.rc

# Kernel
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := $(OUT_DIR)/target/product/oneplus9/$(KERNEL_MODULES_INSTALL)/lib/modules
KERNEL_SD_LLVM_SUPPORT := false

# Keymaster
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.strongbox_keystore.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.strongbox_keystore.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.dm_default_key.options_format.version=2 \
    ro.crypto.volume.metadata.method=dm-default-key

PRODUCT_PACKAGES += \
   android.hardware.keymaster@4.1 \
   android.hardware.keymaster@4.1.vendor

# Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Netflix
PRODUCT_PROPERTY_OVERRIDES += \
    ro.netflix.bsp_rev=Q875-32408-1

# Neural Networks
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.3.vendor

# Overlays
PRODUCT_PACKAGES += \
    AOSPAOnePlus9ProSystemUI \
    AOSPAOnePlus9SeriesFrameworks \
    AOSPAOnePlus9SeriesSettings \
    AOSPAOnePlus9SeriesSystemUI \
    AOSPAOnePlus9SystemUI \
    FrameworksResTarget \
    OnePlus9Frameworks \
    OnePlus9ProFrameworks \
    OnePlus9ProSystemUI \
    OnePlus9SeriesFrameworks \
    OnePlus9SeriesSystemUI \
    OnePlus9SystemUI \
    WifiResTarget

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Platform
TARGET_BOARD_PLATFORM := lahaina

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# QTI
TARGET_COMMON_QTI_COMPONENTS := all

# RIL
PRODUCT_PACKAGES += \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config@1.3.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    android.hardware.secure_element@1.2.vendor \
    android.system.net.netd@1.1 \
    android.system.net.netd@1.1.vendor

# Sensors
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_11/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_9/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-service.multihal \
    libsensorndkbridge

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.sensors.allow_non_default_discovery=true \
    persist.vendor.sensors.on_change_sample_period=true \
    persist.vendor.sensors.sync_request=true

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.sensors.enable.mag_filter=true

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 30

# System Helper
PRODUCT_PACKAGES += \
    vendor.qti.hardware.systemhelper@1.0.vendor

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/thermal/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf

PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.qti

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true

# QTI Trusted UI
PRODUCT_PACKAGES += \
    android.hidl.memory.block@1.0.vendor \

# Update Engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Vendor
$(call inherit-product, vendor/oneplus/oneplus9/oneplus9-vendor.mk)

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.oneplus9

# VNDK
PRODUCT_EXTRA_VNDK_VERSIONS := 30

# WLAN
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wlan/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini
