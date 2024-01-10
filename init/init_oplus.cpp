/*
 * Copyright (C) 2022 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <android-base/logging.h>
#include <android-base/properties.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

using android::base::GetProperty;

/*
 * SetProperty does not allow updating read only properties and as a result
 * does not work for our use case. Write "OverrideProperty" to do practically
 * the same thing as "SetProperty" without this restriction.
 */
void OverrideProperty(const char* name, const char* value) {
    size_t valuelen = strlen(value);

    prop_info* pi = (prop_info*)__system_property_find(name);
    if (pi != nullptr) {
        __system_property_update(pi, value, valuelen);
    } else {
        __system_property_add(name, strlen(name), value, valuelen);
    }
}

/*
 * Only for read-only properties. Properties that can be wrote to more
 * than once should be set in a typical init script (e.g. init.oplus.hw.rc)
 * after the original property has been set.
 */
void vendor_load_properties() {
    auto prj_version = std::stoi(GetProperty("ro.boot.prj_version", "0"));
    auto rf_version = std::stoi(GetProperty("ro.boot.rf_version", "0"));

    switch (prj_version) {
        case 11:
            OverrideProperty("ro.product.odm.device", "OnePlus9Pro");
            OverrideProperty("ro.surface_flinger.set_idle_timer_ms", "250");
            OverrideProperty("ro.surface_flinger.set_touch_timer_ms", "300");
            break;
        case 12:
            OverrideProperty("ro.product.odm.device", "OnePlus9");
            break;
        default:
            LOG(ERROR) << "Unexpected prj version: " << prj_version;
    }

    switch (rf_version) {
        case 11: // CN
            if (prj_version == 12) {
                OverrideProperty("ro.product.odm.model", "LE2110");
            } else if (prj_version == 11) {
                OverrideProperty("ro.product.odm.model", "LE2120");
            }
            break;
        case 12: // TMO
            if (prj_version == 12) {
                OverrideProperty("ro.product.odm.model", "LE2117");
            } else if (prj_version == 11) {
                OverrideProperty("ro.product.odm.model", "LE2127");
            }
            break;
        case 13: // IN
            if (prj_version == 12) {
                OverrideProperty("ro.product.odm.model", "LE2111");
            } else if (prj_version == 11) {
                OverrideProperty("ro.product.odm.model", "LE2121");
            }
            break;
        case 21: // EU
            if (prj_version == 12) {
                OverrideProperty("ro.product.odm.model", "LE2113");
            } else if (prj_version == 11) {
                OverrideProperty("ro.product.odm.model", "LE2123");
            }
            break;
        case 22: // NA
            if (prj_version == 12) {
                OverrideProperty("ro.product.odm.model", "LE2115");
            } else if (prj_version == 11) {
                OverrideProperty("ro.product.odm.model", "LE2125");
            }
            break;
        default:
            LOG(ERROR) << "Unexpected RF version: " << rf_version;
    }
}
