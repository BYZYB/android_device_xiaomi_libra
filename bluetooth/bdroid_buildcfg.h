/*
 * Copyright (c) 2013, The Linux Foundation. All rights reserved.
 * Not a Contribution, Apache license notifications and license are retained
 * for attribution purposes only.
 *
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#pragma push_macro("PROPERTY_VALUE_MAX")

#include <cutils/properties.h>
#include <string.h>

static inline const char *BtmGetDefaultName()
{
    char product_device[PROPERTY_VALUE_MAX];
    property_get("ro.product.device", product_device, "");

    if (strstr(product_device, "aqua"))
        return "Xiaomi Mi 4S";
    if (strstr(product_device, "libra"))
        return "Xiaomi Mi 4C";

    // Fallback to ro.product.model
    return "";
}

#define BLUETOOTH_QTI_SW TRUE
#define BTA_BLE_SKIP_CONN_UPD TRUE
#define BTA_SKIP_BLE_READ_REMOTE_FEAT TRUE
#define BTM_DEF_LOCAL_NAME BtmGetDefaultName()
#define MAX_ACL_CONNECTIONS 7
#define MAX_L2CAP_CHANNELS 16

#pragma pop_macro("PROPERTY_VALUE_MAX")
#endif
