#
# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),libra)
include $(call all-makefiles-under,$(LOCAL_PATH))

# BT_firmware symlinks
BT_FIRMWARE_SYMLINKS := $(TARGET_OUT_VENDOR)/bt_firmware
$(BT_FIRMWARE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(TARGET_OUT_VENDOR)/bt_firmware
ALL_DEFAULT_INSTALLED_MODULES += $(BT_FIRMWARE_SYMLINKS)

# Modem_firmware symlinks
MODEM_FIRMWARE_SYMLINKS := $(TARGET_OUT_VENDOR)/modem_firmware
$(MODEM_FIRMWARE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(TARGET_OUT_VENDOR)/modem_firmware
ALL_DEFAULT_INSTALLED_MODULES += $(MODEM_FIRMWARE_SYMLINKS)

# ADSP symlinks
RFS_MSM_ADSP_SYMLINKS := $(TARGET_OUT)/rfs/msm/adsp/
$(RFS_MSM_ADSP_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@rm -rf $@/*
	@mkdir -p $(dir $@)/readonly
	$(hide) ln -sf /persist/rfs/msm/adsp $@/readwrite
	$(hide) ln -sf /persist/rfs/shared $@/shared
	$(hide) ln -sf /persist/hlos_rfs/shared $@/hlos
	$(hide) ln -sf /firmware $@/readonly/firmware
ALL_DEFAULT_INSTALLED_MODULES += $(RFS_MSM_ADSP_SYMLINKS)

# MPSS symlinks
RFS_MSM_MPSS_SYMLINKS := $(TARGET_OUT)/rfs/msm/mpss/
$(RFS_MSM_MPSS_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@rm -rf $@/*
	@mkdir -p $(dir $@)/readonly
	$(hide) ln -sf /persist/rfs/msm/mpss $@/readwrite
	$(hide) ln -sf /persist/rfs/shared $@/shared
	$(hide) ln -sf /persist/hlos_rfs/shared $@/hlos
	$(hide) ln -sf /firmware $@/readonly/firmware
ALL_DEFAULT_INSTALLED_MODULES += $(RFS_MSM_MPSS_SYMLINKS)

# Vulkan symlinks
VULKAN_SYMLINK := $(TARGET_OUT_VENDOR)/lib/vulkan.$(TARGET_BOARD_PLATFORM).so
$(VULKAN_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	$(hide) ln -sf hw/$(notdir $@) $@
ALL_DEFAULT_INSTALLED_MODULES += $(VULKAN_SYMLINK)

VULKAN_SYMLINK_64 := $(TARGET_OUT_VENDOR)/lib64/vulkan.$(TARGET_BOARD_PLATFORM).so
$(VULKAN_SYMLINK_64): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	$(hide) ln -sf hw/$(notdir $@) $@
ALL_DEFAULT_INSTALLED_MODULES += $(VULKAN_SYMLINK_64)

# WLAN symlinks
WLAN_SYMLINKS := $(TARGET_OUT_ETC)/firmware/wlan/
$(WLAN_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@rm -rf $@/*
	@mkdir -p $(dir $@)/qca_cld
	$(hide) ln -sf /data/vendor/wifi/wlan_mac.bin $@/qca_cld/wlan_mac.bin
ALL_DEFAULT_INSTALLED_MODULES += $(WLAN_SYMLINKS)
endif
