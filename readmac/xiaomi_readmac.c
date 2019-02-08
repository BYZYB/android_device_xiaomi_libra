/*
 * Copyright (C) 2016 The CyanogenMod Project
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

//#define LOG_NDEBUG 0

#define LOG_TAG "xiaomi_readmac"

#include <string.h>
#include <cutils/log.h>
#include <errno.h>

#define XIAOMI_OUI_LIST_SIZE       41
#define MAC_ADDR_SIZE              6
#define WLAN_MAC_BIN               "/data/misc/wifi/wlan_mac.bin"

const uint8_t xiaomi_oui_list[XIAOMI_OUI_LIST_SIZE][3] =
{
    { 0x00, 0x9E, 0xC8 },
    { 0x00, 0xEC, 0x0A },
    { 0x0C, 0x1D, 0xAF },
    { 0x10, 0x2A, 0xB3 },
    { 0x14, 0xF6, 0x5A },
    { 0x18, 0x59, 0x36 },
    { 0x20, 0x82, 0xC0 },
    { 0x28, 0x6C, 0x07 },
    { 0x28, 0xE3, 0x1F },
    { 0x34, 0x80, 0xB3 },
    { 0x34, 0xCE, 0x00 },
    { 0x38, 0xA4, 0xED },
    { 0x3C, 0xBD, 0x3E },
    { 0x4C, 0x49, 0xE3 },
    { 0x50, 0x64, 0x2B },
    { 0x50, 0x8F, 0x4C },
    { 0x58, 0x44, 0x98 },
    { 0x64, 0x09, 0x80 },
    { 0x64, 0xB4, 0x73 },
    { 0x64, 0xCC, 0x2E },
    { 0x68, 0xDF, 0xDD },
    { 0x74, 0x23, 0x44 },
    { 0x74, 0x51, 0xBA },
    { 0x78, 0x02, 0xF8 },
    { 0x78, 0x11, 0xDC },
    { 0x7C, 0x1D, 0xD9 },
    { 0x8C, 0xBE, 0xBE },
    { 0x98, 0xFA, 0xE3 },
    { 0x9C, 0x99, 0xA0 },
    { 0xA0, 0x86, 0xC6 },
    { 0xAC, 0xC1, 0xEE },
    { 0xAC, 0xF7, 0xF3 },
    { 0xB0, 0xE2, 0x35 },
    { 0xC4, 0x0B, 0xCB },
    { 0xC4, 0x6A, 0xB7 },
    { 0xD4, 0x97, 0x0B },
    { 0xEC, 0xD0, 0x9F },
    { 0xF0, 0xB4, 0x29 },
    { 0xF4, 0x8B, 0x32 },
    { 0xF8, 0xA4, 0x5F },
    { 0xFC, 0x64, 0xBA }
};

int qmi_nv_read_wlan_mac(uint8_t **mac);

int xiaomi_is_mac_in_correct_order(uint8_t *mac)
{
    uint8_t zeromac[MAC_ADDR_SIZE] = {0};
    int i = 0;

    // parameter sanity check
    if (!mac || !memcmp(mac, zeromac, MAC_ADDR_SIZE)) {
        return 1;
    }

    for(i = 0; i < XIAOMI_OUI_LIST_SIZE; i++) {
        if(mac[0] == xiaomi_oui_list[i][0] && mac[1] == xiaomi_oui_list[i][1] && mac[2] == xiaomi_oui_list[i][2])
            return 1; // the provided MAC belongs to one of OUIs assigned to Xiaomi
    }

    for(i = 0; i < XIAOMI_OUI_LIST_SIZE; i++) {
        if(mac[5] == xiaomi_oui_list[i][0] && mac[4] == xiaomi_oui_list[i][1] && mac[3] == xiaomi_oui_list[i][2])
            return 0; // the provided MAC in reverse order belongs to one of OUIs assigned to Xiaomi
    }

    return 1; // the provided MAC does not belong to an OUI assigned to Xiaomi
}

int xiaomi_readmac_reverse_mac(uint8_t *mac) {
    uint8_t tmp = 0;
    tmp = mac[0];
    mac[0] = mac[5];
    mac[5] = tmp;

    tmp = mac[0];
    mac[1] = mac[4];
    mac[4] = tmp;

    tmp = mac[0];
    mac[2] = mac[3];
    mac[3] = tmp;

    return 1;
}

int main(void)
{
    uint8_t *mac_addr = NULL;
    uint8_t zeromac[MAC_ADDR_SIZE] = {0};
    FILE *fp;

    // read mac from modem
    qmi_nv_read_wlan_mac(&mac_addr);
    if (!mac_addr || !memcmp(mac_addr, zeromac, MAC_ADDR_SIZE)) {
        ALOGE("qmi_nv_read_wlan_mac error");
        return 1;
    }

    if(0 == xiaomi_is_mac_in_correct_order(mac_addr)) {
        if(0 == xiaomi_readmac_reverse_mac(mac_addr)) {
            ALOGE("xiaomi_readmac_reverse_mac error");
        }
    }

    // generate mac file
    fp = fopen(WLAN_MAC_BIN, "w");
    if (fp==NULL) {
        ALOGE("Can't open wlan_mac.bin: %d", errno);
        return 1;
    }

    fprintf(fp, "Intf0MacAddress=%02X%02X%02X%02X%02X%02X\n",
            mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
    fprintf(fp, "Intf1MacAddress=%02X%02X%02X%02X%02X%02X\n",
            mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]+1);
    fprintf(fp, "END\n");
    fclose(fp);

    return 0;
}
