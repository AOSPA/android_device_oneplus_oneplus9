/*
 * Copyright (C) 2020 The LineageOS Project
 *               2020 Paranoid Android
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

#define LOG_TAG "FingerprintInscreenService"

#include "FingerprintInscreen.h"

#include <android-base/properties.h>
#include <hidl/HidlTransportSupport.h>
#include <fstream>

#define DIM_AMOUNT_PATH "/sys/class/drm/card0-DSI-1/dim_alpha"

#define FOD_HBM_PATH "/sys/class/drm/card0-DSI-1/op_friginer_print_hbm"
#define FOD_HBM_ON 1
#define FOD_HBM_OFF 0

#define FOD_PRESS_PATH "/sys/class/drm/card0-DSI-1/notify_fppress"
#define FOD_NOTIFY_PRESSED 1
#define FOD_NOTIFY_RELEASE 0

using android::base::GetIntProperty;

namespace vendor {
namespace aospa {
namespace biometrics {
namespace fingerprint {
namespace inscreen {
namespace V1_0 {
namespace implementation {

/*
 * Write value to path and close file.
 */
template <typename T>
static void set(const std::string& path, const T& value) {
    std::ofstream file(path);
    file << value;
}

template <typename T>
static T get(const std::string& path, const T& def) {
    std::ifstream file(path);
    T result;

    file >> result;
    return file.fail() ? def : result;
}

Return<void> FingerprintInscreen::onStartEnroll() {
    return Void();
}

Return<void> FingerprintInscreen::onFinishEnroll() {
    return Void();
}

Return<void> FingerprintInscreen::onPress() {
    set(FOD_HBM_PATH, FOD_HBM_ON);
    set(FOD_PRESS_PATH, FOD_NOTIFY_PRESSED);

    return Void();
}

Return<void> FingerprintInscreen::onRelease() {
    set(FOD_HBM_PATH, FOD_HBM_OFF);
    set(FOD_PRESS_PATH, FOD_NOTIFY_RELEASE);

    return Void();
}

Return<void> FingerprintInscreen::onShowFODView() {
    return Void();
}

Return<void> FingerprintInscreen::onHideFODView() {
    return Void();
}

Return<bool> FingerprintInscreen::handleAcquired(int32_t, int32_t) {
    return false;
}

Return<bool> FingerprintInscreen::handleError(int32_t, int32_t) {
    return false;
}

Return<void> FingerprintInscreen::setLongPressEnabled(bool) {
    return Void();
}

Return<int32_t> FingerprintInscreen::getDimAmount(int32_t) {
    int dimAmount = get(DIM_AMOUNT_PATH, 0);

    return dimAmount;
}

Return<bool> FingerprintInscreen::shouldBoostBrightness() {
    return false;
}

Return<void> FingerprintInscreen::setCallback(const sp<IFingerprintInscreenCallback>&) {
    return Void();
}

Return<int32_t> FingerprintInscreen::getPositionX() {
    auto fodPosX = GetIntProperty("persist.sys.fod.pos.x", 0);

    return fodPosX;
}

Return<int32_t> FingerprintInscreen::getPositionY() {
    auto fodPosY = GetIntProperty("persist.sys.fod.pos.y", 0);

    return fodPosY;
}

Return<int32_t> FingerprintInscreen::getSize() {
    auto fodSize = GetIntProperty("persist.sys.fod.size", 0);

    return fodSize;
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace inscreen
}  // namespace fingerprint
}  // namespace biometrics
}  // namespace aospa
}  // namespace vendor
