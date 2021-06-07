/*
   Copyright (c) 2020, The LineageOS Project
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

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#define AQUA_BOARD_ID 30
#define BOARD_ID_PATH "/proc/device-tree/qcom,board-id"
#define LIBRA_BOARD_ID 12
#define RAM_SIZE_2GB 2048ull * 1024 * 1024

#include <fstream>
#include <sys/_system_properties.h>
#include <sys/sysinfo.h>

uint8_t get_board_id(const char *path)
{
    uint8_t board_id;

    /*
      qcom,board-id contains two 4-byte numbers,
      For libra, 00 00 00 0c and 00 00 00 00.
      For aqua, 00 00 00 1e and 00 00 00 00.
     */
    std::ifstream board_id_file(path, std::ifstream::binary);
    board_id_file.seekg(3); // Shift past the first 3 bytes and only read the 4th one
    board_id_file.read(reinterpret_cast<char *>(&board_id), 1);

    return board_id;
}

void property_override(const char *prop, const char *value)
{
    prop_info *info = (prop_info *)__system_property_find(prop);

    if (info) // Update existing property
    {
        __system_property_update(info, value, strlen(value));
    }
    else // Create new property
    {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void vendor_load_properties()
{
    switch (get_board_id(BOARD_ID_PATH))
    {
    case LIBRA_BOARD_ID:
    {
        struct sysinfo sys;
        sysinfo(&sys);

        // Set memory properties for Mi-4c with 2GB RAM (values from phone-xhdpi-2048-dalvik-heap.mk)
        if (sys.totalram <= RAM_SIZE_2GB)
        {
            property_override("dalvik.vm.heapgrowthlimit", "192m");
            property_override("dalvik.vm.heapmaxfree", "8m");
            property_override("dalvik.vm.heapminfree", "512k");
            property_override("dalvik.vm.heapsize", "512m");
            property_override("dalvik.vm.heapstartsize", "8m");
            property_override("dalvik.vm.heaptargetutilization", "0.75");
            property_override("ro.config.low_ram", "true");
        }

        break;
    }

    case AQUA_BOARD_ID:
    {
        // Set device info for Mi-4s
        property_override("ro.build.product", "aqua");
        property_override("ro.product.device", "aqua");
        property_override("ro.product.model", "Mi-4s");
        property_override("ro.vendor.product.device", "aqua");
        property_override("ro.vendor.product.model", "Mi-4s");

        // Set fingerprint properties
        property_override("ro.frp.pst", "/dev/block/bootdevice/by-name/config");
        property_override("ro.hardware.fingerprint", "fpc");
        property_override("sys.fpc.tu.disabled", "0");

        break;
    }
    }

    // Hide sensitive IMEI and MEID properties
    property_override("ro.ril.oem.imei", "");
    property_override("ro.ril.oem.imei1", "");
    property_override("ro.ril.oem.meid", "");
}
