LOCAL_PATH := $(call my-dir)

# /vendor
include $(CLEAR_VARS)
LOCAL_MODULE := ueventd.qcom.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)
LOCAL_MODULE_STEM := ueventd.rc
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/ueventd.qcom.rc
include $(BUILD_PREBUILT)

# /vendor/bin
include $(CLEAR_VARS)
LOCAL_MODULE := init.custom.post_boot.sh
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_EXECUTABLES)
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := bin/init.custom.post_boot.sh
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := init.qcom.post_boot.sh
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_EXECUTABLES)
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := bin/init.qcom.post_boot.sh
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := init.qcom.sh
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_EXECUTABLES)
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := bin/init.qcom.sh
include $(BUILD_PREBUILT)

# /vendor/etc
include $(CLEAR_VARS)
LOCAL_MODULE := fstab.qcom
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/fstab.qcom
include $(BUILD_PREBUILT)

# /vendor/etc/init/hw
include $(CLEAR_VARS)
LOCAL_MODULE := init.fpc.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/init/hw
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/init.fpc.rc
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := init.qcom.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/init/hw
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/init.qcom.rc
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := init.qcom.usb.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/init/hw
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/init.qcom.usb.rc
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := init.target.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/init/hw
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := etc/init.target.rc
include $(BUILD_PREBUILT)
