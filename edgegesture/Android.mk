LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-java-files-under, src)

LOCAL_CERTIFICATE := platform
LOCAL_DEX_PREOPT := true
LOCAL_MODULE_TAGS := optional
LOCAL_PACKAGE_NAME := EdgeGesture
LOCAL_PRIVATE_PLATFORM_APIS := true
LOCAL_PRIVILEGED_MODULE := true
LOCAL_PROGUARD_FLAG_FILES := proguard.flags
LOCAL_USE_AAPT2 := true

LOCAL_STATIC_ANDROID_LIBRARIES := \
    android-support-v4 \
    android-support-v7-appcompat \
    android-support-v7-preference \
    android-support-v7-recyclerview \
    android-support-v13 \
    android-support-v14-preference

LOCAL_STATIC_JAVA_LIBRARIES := \
    org.lineageos.platform.internal

LOCAL_RESOURCE_DIR := \
    $(LOCAL_PATH)/res \
    $(TOP)/packages/resources/devicesettings/res

include $(BUILD_PACKAGE)
