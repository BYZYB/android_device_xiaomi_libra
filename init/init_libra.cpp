/*
   Copyright (c) 2016, The CyanogenMod Project
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <sys/sysinfo.h>
#include <fstream>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"

using android::init::property_set;

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_dual(char const system_prop[],
        char const vendor_prop[], char const value[])
{
    property_override(system_prop, value);
    property_override(vendor_prop, value);
}

char const *heapstartsize;
char const *heapgrowthlimit;
char const *heapsize;
char const *heapminfree;

uint8_t board_id;

void set_dalvik_values()
{
    struct sysinfo sys;

    sysinfo(&sys);

    if (sys.totalram > 2048ull * 1024 * 1024) {
        // from - phone-xxhdpi-3072-dalvik-heap.mk
        heapstartsize = "8m";
        heapgrowthlimit = "288m";
        heapsize = "768m";
        heapminfree = "512k";
    } else {
        // from - phone-xxhdpi-2048-dalvik-heap.mk
        heapstartsize = "16m";
        heapgrowthlimit = "192m";
        heapsize = "512m";
        heapminfree = "2m";
    }
}

#define BOARD_ID_PATH "/proc/device-tree/qcom,board-id"
#define LIBRA_BOARD_ID 12
#define AQUA_BOARD_ID 30

void set_board_id()
{
    /*
      qcom,board-id contains 2 4-byte numbers,
      For libra, 00 00 00 0c and 00 00 00 00.
      For aqua, 00 00 00 1e and 00 00 00 00.
     */
    std::ifstream board_id_file(BOARD_ID_PATH, std::ifstream::binary);
    /*
      Shift past the first 3 bytes, and only read the 4th one.
     */
    board_id_file.seekg(3);
    board_id_file.read(reinterpret_cast<char *>(&board_id), 1);
}

void vendor_load_properties()
{
    set_dalvik_values();

    property_set("dalvik.vm.heapstartsize", heapstartsize);
    property_set("dalvik.vm.heapgrowthlimit", heapgrowthlimit);
    property_set("dalvik.vm.heapsize", heapsize);
    property_set("dalvik.vm.heaptargetutilization", "0.75");
    property_set("dalvik.vm.heapminfree", heapminfree);
    property_set("dalvik.vm.heapmaxfree", "8m");

    set_board_id();

    switch(board_id) {
    case LIBRA_BOARD_ID:
        property_override_dual("ro.product.model", "ro.vendor.product.model", "Mi4c");
        property_override_dual("ro.product.device", "ro.vendor.product.device", "libra");
        property_override("ro.build.description", "libra-user 7.0 NRD90M V9.5.2.0.NXKCNFA release-keys");
        property_override_dual("ro.build.fingerprint", "ro.vendor.build.fingerprint", "Xiaomi/libra/libra:7.0/NRD90M/V9.5.2.0.NXKCNFA:user/release-keys");
        property_override("ro.build.product", "libra");
        break;
    case AQUA_BOARD_ID:
        property_override_dual("ro.product.model", "ro.vendor.product.model", "Mi4s");
        property_override_dual("ro.product.device", "ro.vendor.product.device", "aqua");
        property_override("ro.build.description", "aqua-user 7.0 NRD90M V9.5.2.0.NXKCNFA release-keys");
        property_override_dual("ro.build.fingerprint", "ro.vendor.build.fingerprint", "Xiaomi/aqua/aqua:7.0/NRD90M/V9.5.2.0.NXKCNFA:user/release-keys");
        property_override("ro.build.product", "aqua");
        break;
    }
}
