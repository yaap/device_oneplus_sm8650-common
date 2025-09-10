/*
 * Copyright (C) 2022-2025 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <android-base/logging.h>
#include <android-base/parseint.h>
#include <android-base/properties.h>

#include <fs_mgr.h>

#include <string>
#include <unordered_map>

namespace android {
namespace init {
uint32_t InitPropertySet(const std::string& name, const std::string& value);
}  // namespace init
}  // namespace android

using android::base::ParseInt;
using android::fs_mgr::GetKernelCmdline;
using android::init::InitPropertySet;

namespace {
constexpr std::string kCmdlineRegion = "oplus_region";
const std::unordered_map<int, std::string> kRegionMap = {
        {27, "IN"},
        {68, "EU"},
        {151, "CN"},
        {161, "NA"},
        {167, "ROW"},
};
}  // anonymous namespace

/*
 * Only for read-only properties. Properties that can be wrote to more
 * than once should be set in a typical init script (e.g. init.oplus.hw.rc)
 * after the original property has been set.
 */
void vendor_process_bootenv() {
    std::string buf;
    if (!GetKernelCmdline(kCmdlineRegion, &buf)) {
        LOG(ERROR) << kCmdlineRegion << " not found in /proc/cmdline";
        return;
    }

    int region_id;
    if (!ParseInt(buf, &region_id)) {
        LOG(ERROR) << "Region ID [" << buf << "] is invalid";
        return;
    }

    auto it = kRegionMap.find(region_id);
    if (it == kRegionMap.end()) {
        LOG(ERROR) << "Unexpected region ID: " << region_id;
    } else {
        InitPropertySet("ro.boot.hardware.revision", it->second);
    }
}