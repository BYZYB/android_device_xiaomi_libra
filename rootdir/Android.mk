#
# Copyright (C) 2019 The LineageOS Project
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

# Temporary solution for making ueventd.rc
# This file must be put into "/vendor", which has no way to do with blueprint (Android.bp)
include $(CLEAR_VARS)
LOCAL_MODULE := ueventd.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/ueventd.rc
include $(BUILD_PREBUILT)
