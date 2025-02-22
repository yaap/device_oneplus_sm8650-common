#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_FIRMWARE=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common)
            ONLY_COMMON=true
            ;;
        --only-firmware)
            ONLY_FIRMWARE=true
            ;;
        --only-target)
            ONLY_TARGET=true
            ;;
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
        odm/bin/hw/android.hardware.secure_element-service.qti|vendor/lib64/qcrilNr_aidl_SecureElementService.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.secure_element-V1-ndk.so" "android.hardware.secure_element-V1-ndk_odm.so" "${2}"
            ;;
        odm/bin/hw/vendor.oplus.hardware.biometrics.fingerprint@2.1-service_uff)
            [ "$2" = "" ] && return 0
            grep -q "libshims_aidl_fingerprint_v3.oplus.so" "${2}" || "${PATCHELF}" --add-needed "libshims_aidl_fingerprint_v3.oplus.so" "${2}"
            ;;
        odm/etc/camera/CameraHWConfiguration.config)
            [ "$2" = "" ] && return 0
            sed -i "/SystemCamera = / s/1;/0;/g" "${2}"
            ;;
        odm/etc/init/vendor.oplus.hardware.biometrics.fingerprint@2.1-service.rc)
            [ "$2" = "" ] && return 0
            sed -i "8i\    task_profiles ProcessCapacityHigh MaxPerformance" "${2}"
            ;;
        odm/etc/permissions/vendor-oplus-hardware-charger.xml)
            [ "$2" = "" ] && return 0
            sed -i "s|/system/system_ext|/system_ext|g" "${2}"
            ;;
        odm/lib64/libAlgoProcess.so)
            [ "$2" = "" ] && return 0
            sed -i "s/android.hardware.graphics.common-V3-ndk.so/android.hardware.graphics.common-V5-ndk.so/" "${2}"
            sed -i "s/android.hardware.graphics.common-V4-ndk.so/android.hardware.graphics.common-V5-ndk.so/" "${2}"
            ;;
        odm/lib64/libCOppLceTonemapAPI.so|odm/lib64/libCS.so|odm/lib64/libSuperRaw.so|odm/lib64/libYTCommon.so|odm/lib64/libyuv2.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;
        odm/lib64/camera.device@3.3-impl_odm.so|odm/lib64/vendor.oplus.hardware.virtual_device.camera.provider@2.4-impl.so|odm/lib64/vendor.oplus.hardware.virtual_device.camera.provider@2.5-impl.so|odm/lib64/vendor.oplus.hardware.virtual_device.camera.provider@2.6-impl.so|odm/lib64/vendor.oplus.hardware.virtual_device.camera.provider@2.7-impl.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "camera.device@3.2-impl.so" "camera.device@3.2-impl_odm.so" "${2}"
            "${PATCHELF}" --replace-needed "camera.device@3.3-impl.so" "camera.device@3.3-impl_odm.so" "${2}"
            ;;
        odm/lib64/vendor.oplus.hardware.virtual_device.camera.manager@1.0-impl.so|vendor/lib64/libcwb_qcom_aidl.so)
            [ "$2" = "" ] && return 0
            grep -q "libui_shim.so" "${2}" || "${PATCHELF}" --add-needed "libui_shim.so" "${2}"
            ;;
        product/etc/sysconfig/com.android.hotwordenrollment.common.util.xml)
            [ "$2" = "" ] && return 0
            sed -i "s/\/my_product/\/product/" "${2}"
            ;;
        system_ext/lib64/libwfdnative.so)
            [ "$2" = "" ] && return 0
            sed -i "s/android.hidl.base@1.0.so/libhidlbase.so\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00/" "${2}"
            grep -q libinput_shim.so "$2" || "$PATCHELF" --add-needed libinput_shim.so "$2"
            ;;
        system_ext/lib64/libwfdservice.so)
            [ "$2" = "" ] && return 0
            sed -i "s/android.media.audio.common.types-V2-cpp.so/android.media.audio.common.types-V4-cpp.so/" "${2}"
            ;;
        vendor/bin/system_dlkm_modprobe.sh)
            [ "$2" = "" ] && return 0
            sed -i "/zram or zsmalloc/d" "${2}"
            sed -i "s/-e \"zram\" -e \"zsmalloc\"//g" "${2}"
            ;;
        vendor/etc/init/vendor.qti.camera.provider-service_64.rc)
            sed -i "6i\    setenv JE_MALLOC_ZERO_FILLING 1" "${2}"
            [ "$2" = "" ] && return 0
            ;;
        vendor/etc/libnfc-nci.conf)
            [ "$2" = "" ] && return 0
            sed -i "s/NFC_DEBUG_ENABLED=1/NFC_DEBUG_ENABLED=0/" "${2}"
            ;;
        vendor/etc/libnfc-nxp.conf)
            [ "$2" = "" ] && return 0
            sed -i "/NXPLOG_\w\+_LOGLEVEL/ s/0x03/0x02/" "${2}"
            sed -i "s/NFC_DEBUG_ENABLED=1/NFC_DEBUG_ENABLED=0/" "${2}"
            ;;
        vendor/etc/media_codecs_pineapple.xml|vendor/etc/media_codecs_pineapple_vendor.xml)
            [ "$2" = "" ] && return 0
            sed -Ei "/media_codecs_(google_audio|google_c2|google_telephony|google_video|vendor_audio)/d" "${2}"
            sed -i "s/media_codecs_vendor_audio/media_codecs_dolby_audio/" "${2}"
            ;;
        vendor/lib64/libqcodec2_core.so)
            [ "$2" = "" ] && return 0
            grep -q "libcodec2_shim.so" "${2}" || "${PATCHELF}" --add-needed "libcodec2_shim.so" "${2}"
            ;;
        vendor/lib64/vendor.libdpmframework.so)
            [ "$2" = "" ] && return 0
            grep -q "libhidlbase_shim.so" "${2}" || "${PATCHELF}" --add-needed "libhidlbase_shim.so" "${2}"
            ;;
        vendor/lib64/libstagefright_soft_ddpdec.so|vendor/lib64/libdlbdsservice.so|vendor/lib64/libstagefright_soft_ac4dec.so|vendor/lib64/libstagefrightdolby.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
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

if [ -z "${ONLY_FIRMWARE}" ] && [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../../${VENDOR}/${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    if [ -z "${ONLY_FIRMWARE}" ]; then
        extract "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
    fi

    if [ -z "${SECTION}" ] && [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" ]; then
        extract_firmware "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" "${SRC}"
    fi
fi

"${MY_DIR}/setup-makefiles.sh"
