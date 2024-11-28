#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-FileCopyrightText: 2022 Paranoid Android

# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=oneplus9
VENDOR=oneplus

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup)
            CLEAN_VENDOR=false
            ;;
        -k | --kang)
            KANG="--kang"
            ;;
        -s | --section)
            SECTION="${2}"
            shift
            CLEAN_VENDOR=false
            ;;
        *)
            SRC="${1}"
            ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        odm/etc/camera/CameraHWConfiguration.config)
            [ "$2" = "" ] && return 0
            sed -i "/SystemCamera = / s/1;/0;/g" "${2}"
            ;;
        odm/lib/liblvimfs_wrapper.so | odm/lib64/libCOppLceTonemapAPI.so | vendor/lib64/libalsc.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;
        odm/lib64/libAlgoProcess.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.graphics.common-V1-ndk_platform.so" "android.hardware.graphics.common-V5-ndk.so" "${2}"
            ;;
        odm/lib64/mediadrm/libwvdrmengine.so|odm/lib64/libwvhidl.so)
            [ "$2" = "" ] && return 0
            grep -q "libcrypto_shim.so" "${2}" || "${PATCHELF}" --add-needed "libcrypto_shim.so" "${2}"
            ;;
        odm/overlay/prj_11/odm/etc/camera/CameraHWConfiguration.config)
            [ "$2" = "" ] && return 0
            sed -i "/SystemCamera = / s/1;/0;/g" "${2}"
            ;;
        product/etc/sysconfig/com.android.hotwordenrollment.common.util.xml)
            [ "$2" = "" ] && return 0
            sed -i "s/my_product/product/" "${2}"
            ;;
        vendor/etc/media_codecs.xml|vendor/etc/media_codecs_lahaina.xml|vendor/etc/media_codecs_lahaina_vendor.xml)
            [ "$2" = "" ] && return 0
            sed -Ei "/media_codecs_(google_audio|google_c2|google_telephony|vendor_audio)/d" "${2}"
            ;;
        vendor/etc/seccomp_policy/atfwd@2.0.policy)
            [ "$2" = "" ] && return 0
            grep -q "gettid: 1" "${2}" || echo "gettid: 1" >> "${2}"
            ;;
        vendor/lib/hw/audio.primary.lahaina.so)
            [ "$2" = "" ] && return 0
            sed -i "s/\/vendor\/lib\/liba2dpoffload.so/\/odm\/lib\/liba2dpoffload.so\x00\x00\x00/" "${2}"
            sed -i "s/\/vendor\/lib\/libssrec.so/\/odm\/lib\/libssrec.so\x00\x00\x00/" "${2}"
            "${PATCHELF}" --replace-needed "libgui1_vendor.so" "libgui_vendor.so" "${2}"
            ;;
        vendor/lib/libextcamera_client.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libgui1_vendor.so" "libgui_vendor.so" "${2}"
            ;;
        vendor/lib64/hw/com.qti.chi.override.so)
            [ "$2" = "" ] && return 0
            "${SIGSCAN}" -p "45 B8 05 94" -P "1F 20 03 D5" -f "${2}"
            ;;
        vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so)
            [ "$2" = "" ] && return 0
            "${SIGSCAN}" -p "23 0B 00 94" -P "1F 20 03 D5" -f "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
