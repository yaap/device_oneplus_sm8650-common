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
            "${PATCHELF}" --replace-needed "libtinyxml2.so" "libtinyxml2_stock.so" "${2}"
            ;;
        odm/etc/resourcemanager.xml)
            [ "$2" = "" ] && return 0
            sed -i "s|\(<speaker_protection_enabled>\)1\(</speaker_protection_enabled>\)|\10\2|" "${2}"
            ;;
        odm/etc/init/vendor.oplus.hardware.biometrics.fingerprint@2.1-service.rc)
            [ "$2" = "" ] && return 0
            sed -i "8i\    task_profiles ProcessCapacityHigh MaxPerformance" "${2}"
            ;;
        odm/etc/init/init.touchDaemon.rc)
            [ "$2" = "" ] && return 0
            sed -i "7i\    task_profiles ProcessCapacityHigh MaxPerformance" "${2}"
            ;;
        odm/etc/permissions/vendor-oplus-hardware-charger.xml)
            [ "$2" = "" ] && return 0
            sed -i "s|/system/system_ext|/system_ext|g" "${2}"
            ;;
        vendor/etc/seccomp_policy/atfwd@2.0.policy)
            [ "$2" = "" ] && return 0
            grep -q "gettid: 1" "${2}" || echo -e "\ngettid: 1" >> "${2}"
            ;;
        vendor/etc/seccomp_policy/gnss@2.0-qsap-location.policy)
            [ "$2" = "" ] && return 0
            grep -q "sched_get_priority_min: 1" "${2}" || echo -e "\nsched_get_priority_min: 1" >> "${2}"
            grep -q "sched_get_priority_max: 1" "${2}" || echo -e "\nsched_get_priority_max: 1" >> "${2}"
            ;;
        odm/lib64/vendor.oplus.hardware.virtual_device.camera.manager@1.0-impl.so|vendor/lib64/libcwb_qcom_aidl.so)
            [ "$2" = "" ] && return 0
            grep -q "libui_shim.so" "${2}" || "${PATCHELF}" --add-needed "libui_shim.so" "${2}"
            ;;
        product/etc/sysconfig/com.android.hotwordenrollment.common.util.xml)
            [ "$2" = "" ] && return 0
            sed -i "s/\/my_product/\/product/" "${2}"
            ;;
        system_ext/bin/horae)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-21.7.so" "${2}"
            ;;
        system_ext/lib64/vendor.qti.hardware.qccsyshal@1.2-halimpl.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-21.7.so" "${2}"
            ;;
       |vendor/bin/qvrdatauploader \
       |odm/bin/hw/vendor-oplus-hardware-touch-V2-service \
       |odm/bin/touchDaemon)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libtinyxml2.so" "libtinyxml2_stock.so" "${2}"
            ;;
        vendor/lib64/libcapiv2uvvendor.so|vendor/lib64/liblistensoundmodel2vendor.so \
	|vendor/lib64/libVoiceSdk.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libtensorflowlite_c.so" "libtensorflowlite_c_vendor.so" "${2}"
            ;;
        vendor/bin/init.kernel.post_boot-memory.sh)
            [ "$2" = "" ] && return 0
            sed -i "s/# echo always/echo always/" "${2}"
            ;;
        vendor/bin/system_dlkm_modprobe.sh)
            [ "$2" = "" ] && return 0
            sed -i "/zram or zsmalloc/d" "${2}"
            sed -i "s/-e \"zram\" -e \"zsmalloc\"//g" "${2}"
            ;;
        vendor/etc/media_codecs_pineapple.xml|vendor/etc/media_codecs_pineapple_vendor.xml)
            [ "$2" = "" ] && return 0
            sed -Ei "/media_codecs_(google_audio|google_c2|google_telephony|google_video|vendor_audio)/d" "${2}"
            ;;
        vendor/lib64/libqcodec2_core.so)
            [ "$2" = "" ] && return 0
            grep -q "libcodec2_shim.so" "${2}" || "${PATCHELF}" --add-needed "libcodec2_shim.so" "${2}"
            ;;
        vendor/lib64/libqcrilNr.so|vendor/lib64/libril-db.so)
            [ "$2" = "" ] && return 0
            sed -i "s|persist.vendor.radio.poweron_opt|persist.vendor.radio.poweron_ign|" "${2}"
            ;;
        vendor/lib64/vendor.libdpmframework.so)
            [ "$2" = "" ] && return 0
            grep -q "libbinder_shim.so" "${2}" || "${PATCHELF}" --add-needed "libbinder_shim.so" "${2}"
            grep -q "libhidlbase_shim.so" "${2}" || "${PATCHELF}" --add-needed "libhidlbase_shim.so" "${2}"
            ;;
        vendor/bin/qcc-vendor|vendor/bin/qms|vendor/bin/xtra-daemon|vendor/lib64/libqms_client.so|vendor/lib64/libqcc_sdk.so|vendor/lib64/libcne.so)
            [ "$2" = "" ] && return 0
            grep -q "libbinder_shim.so" "${2}" || "${PATCHELF}" --add-needed "libbinder_shim.so" "${2}"
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
