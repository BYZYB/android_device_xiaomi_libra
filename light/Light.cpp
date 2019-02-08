/*
 * Copyright (C) 2017-2018 The LineageOS Project
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

#define LOG_TAG "LightService"

#include <log/log.h>

#include "Light.h"

#include <fstream>

#define LEDS            "/sys/class/leds/"

#define LCD_LED         LEDS "lcd-backlight/"
#define BUTTON_LED      LEDS "button-backlight/"
#define BUTTON1_LED     LEDS "button-backlight1/"
#define RED_LED         LEDS "red/"
#define GREEN_LED       LEDS "green/"
#define BLUE_LED        LEDS "blue/"
#define RGB_LED         LEDS "rgb/"

#define BRIGHTNESS      "brightness"
#define DUTY_PCTS       "duty_pcts"
#define START_IDX       "start_idx"
#define PAUSE_LO        "pause_lo"
#define PAUSE_HI        "pause_hi"
#define RAMP_STEP_MS    "ramp_step_ms"
#define RGB_BLINK       "rgb_blink"

#define MAX_LED_BRIGHTNESS    255
#define MAX_LCD_BRIGHTNESS    3200

/*
 * 8 duty percent steps.
 */
#define RAMP_STEPS 8
/*
 * Each step will stay on for 50ms by default.
 */
#define RAMP_STEP_DURATION 50
/*
 * Each value represents a duty percent (0 - 100) for the led pwm.
 */
static int32_t BRIGHTNESS_RAMP[RAMP_STEPS] = {0, 12, 25, 37, 50, 72, 85, 100};

namespace {
/*
 * Write value to path and close file.
 */
static void set(std::string path, std::string value) {
    std::ofstream file(path);

    if (!file.is_open()) {
        ALOGE("failed to write %s to %s", value.c_str(), path.c_str());
        return;
    }

    file << value;
}

static void set(std::string path, int value) {
    set(path, std::to_string(value));
}

static uint32_t getBrightness(const LightState& state) {
    uint32_t alpha, red, green, blue;

    /*
     * Extract brightness from AARRGGBB.
     */
    alpha = (state.color >> 24) & 0xFF;
    red = (state.color >> 16) & 0xFF;
    green = (state.color >> 8) & 0xFF;
    blue = state.color & 0xFF;

    /*
     * Scale RGB brightness if Alpha brightness is not 0xFF.
     */
    if (alpha != 0xFF) {
        red = red * alpha / 0xFF;
        green = green * alpha / 0xFF;
        blue = blue * alpha / 0xFF;
    }

    return (77 * red + 150 * green + 29 * blue) >> 8;
}

static inline uint32_t scaleBrightness(uint32_t brightness, uint32_t maxBrightness) {
    return brightness * maxBrightness / 0xFF;
}

static inline uint32_t getScaledBrightness(const LightState& state, uint32_t maxBrightness) {
    return scaleBrightness(getBrightness(state), maxBrightness);
}

static void handleBacklight(const LightState& state) {
    uint32_t brightness = getScaledBrightness(state, MAX_LCD_BRIGHTNESS);
    set(LCD_LED BRIGHTNESS, brightness);
}

static void handleButtons(const LightState& state) {
    uint32_t brightness = getScaledBrightness(state, MAX_LED_BRIGHTNESS);
    set(BUTTON_LED BRIGHTNESS, brightness);
    set(BUTTON1_LED BRIGHTNESS, brightness);
}

/*
 * Scale each value of the brightness ramp according to the
 * brightness of the color.
 */
static std::string getScaledRamp(uint32_t brightness) {
    std::string ramp, pad;

    for (auto const& step : BRIGHTNESS_RAMP) {
        int32_t scaledStep = (step * brightness) / 0xFF;
        ramp += pad + std::to_string(scaledStep);
        pad = ",";
    }

    return ramp;
}

static void handleNotification(const LightState& state) {
    uint32_t redBrightness, greenBrightness, blueBrightness, brightness;

    /*
     * Extract brightness from AARRGGBB.
     */
    redBrightness = (state.color >> 16) & 0xFF;
    greenBrightness = (state.color >> 8) & 0xFF;
    blueBrightness = state.color & 0xFF;

    brightness = (state.color >> 24) & 0xFF;

    /*
     * Scale RGB brightness if the Alpha brightness is not 0xFF.
     */
    if (brightness != 0xFF) {
        redBrightness = (redBrightness * brightness) / 0xFF;
        greenBrightness = (greenBrightness * brightness) / 0xFF;
        blueBrightness = (blueBrightness * brightness) / 0xFF;
    }

    /* Disable blinking. */
    set(RGB_LED RGB_BLINK, 0);

    if (state.flashMode == Flash::TIMED) {
        /*
         * If the flashOnMs duration is not long enough to fit ramping up
         * and down at the default step duration, step duration is modified
         * to fit.
         */
        int32_t stepDuration = RAMP_STEP_DURATION;
        int32_t pauseHi = state.flashOnMs - (stepDuration * RAMP_STEPS * 2);
        int32_t pauseLo = state.flashOffMs;

        if (pauseHi < 0) {
            stepDuration = state.flashOnMs / (RAMP_STEPS * 2);
            pauseHi = 0;
        }

        /* Red */
        set(RED_LED START_IDX, 0 * RAMP_STEPS);
        set(RED_LED DUTY_PCTS, getScaledRamp(redBrightness));
        set(RED_LED PAUSE_LO, pauseLo);
        set(RED_LED PAUSE_HI, pauseHi);
        set(RED_LED RAMP_STEP_MS, stepDuration);

        /* Green */
        set(GREEN_LED START_IDX, 1 * RAMP_STEPS);
        set(GREEN_LED DUTY_PCTS, getScaledRamp(greenBrightness));
        set(GREEN_LED PAUSE_LO, pauseLo);
        set(GREEN_LED PAUSE_HI, pauseHi);
        set(GREEN_LED RAMP_STEP_MS, stepDuration);

        /* Blue */
        set(BLUE_LED START_IDX, 2 * RAMP_STEPS);
        set(BLUE_LED DUTY_PCTS, getScaledRamp(blueBrightness));
        set(BLUE_LED PAUSE_LO, pauseLo);
        set(BLUE_LED PAUSE_HI, pauseHi);
        set(BLUE_LED RAMP_STEP_MS, stepDuration);

        /* Enable blinking. */
        set(RGB_LED RGB_BLINK, 1);
    } else {
        set(RED_LED BRIGHTNESS, redBrightness);
        set(GREEN_LED BRIGHTNESS, greenBrightness);
        set(BLUE_LED BRIGHTNESS, blueBrightness);
    }
}

static inline bool isLit(const LightState& state) {
    return state.color & 0x00ffffff;
}

/* Keep sorted in the order of importance. */
static std::vector<LightBackend> backends = {
    { Type::ATTENTION, handleNotification },
    { Type::NOTIFICATIONS, handleNotification },
    { Type::BATTERY, handleNotification },
    { Type::BACKLIGHT, handleBacklight },
    { Type::BUTTONS, handleButtons },
};

}  // anonymous namespace

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

Return<Status> Light::setLight(Type type, const LightState& state) {
    LightStateHandler handler;
    bool handled = false;

    /* Lock global mutex until light state is updated. */
    std::lock_guard<std::mutex> lock(globalLock);

    /* Update the cached state value for the current type. */
    for (LightBackend& backend : backends) {
        if (backend.type == type) {
            backend.state = state;
            handler = backend.handler;
        }
    }

    /* If no handler has been found, then the type is not supported. */
    if (!handler) {
        return Status::LIGHT_NOT_SUPPORTED;
    }

    /* Light up the type with the highest priority that matches the current handler. */
    for (LightBackend& backend : backends) {
        if (handler == backend.handler && isLit(backend.state)) {
            handler(backend.state);
            handled = true;
            break;
        }
    }

    /* If no type has been lit up, then turn off the hardware. */
    if (!handled) {
        handler(state);
    }

    return Status::SUCCESS;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    std::vector<Type> types;

    for (const LightBackend& backend : backends) {
        types.push_back(backend.type);
    }

    _hidl_cb(types);

    return Void();
}

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
