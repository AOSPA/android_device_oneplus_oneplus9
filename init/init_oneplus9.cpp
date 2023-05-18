/*
 * Copyright (C) 2021 Paranoid Android
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <android-base/properties.h>
#include "util.h"

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

using android::base::GetProperty;
using android::init::IsRecoveryMode;

/*
 * SetProperty does not allow updating read only properties and as a result
 * does not work for our use case. Write "OverrideProperty" to do practically
 * the same thing as "SetProperty" without this restriction.
 */
void OverrideProperty(const std::string& name, const std::string& value) {
    size_t valuelen = value.size();

    prop_info* pi = (prop_info*)__system_property_find(name.c_str());
    if (pi != nullptr) {
        __system_property_update(pi, value.c_str(), valuelen);
    } else {
        __system_property_add(name.c_str(), name.size(), value.c_str(), valuelen);
    }
}

/*
 * Only for read-only properties. Properties that can be wrote to more
 * than once should be set in a typical init script (e.g. init.oneplus.rc)
 * after the original property has been set.
 */
void vendor_load_properties() {
    std::string variant = GetProperty("ro.boot.prj_version", "");
    if (!IsRecoveryMode()) {
        if (variant == "11") {
            OverrideProperty("ro.product.product.model", "OnePlus 9 Pro");
            OverrideProperty("ro.product.product.device", "OnePlus9Pro");
            OverrideProperty("ro.sf.lcd_density", "480");
        } else if (variant == "12") {
            OverrideProperty("ro.product.product.device", "OnePlus9");
        }
    }
}
