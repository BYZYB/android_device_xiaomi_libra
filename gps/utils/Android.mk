ifneq ($(BUILD_TINY_ANDROID),true)
#Compile this library only for builds with the latest modem image

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

## Libs
LOCAL_SHARED_LIBRARIES := \
    libutils \
    libcutils \
    liblog

LOCAL_SRC_FILES += \
    loc_log.cpp \
    loc_cfg.cpp \
    msg_q.c \
    linked_list.c \
    loc_target.cpp \
    platform_lib_abstractions/elapsed_millis_since_boot.cpp \
    LocHeap.cpp \
    LocTimer.cpp \
    LocThread.cpp \
    MsgTask.cpp \
    loc_misc_utils.cpp

# Flag -std=c++11 is not accepted by compiler when LOCAL_CLANG is set to true
LOCAL_CFLAGS += \
    -fno-short-enums \
    -D_ANDROID_

ifeq ($(TARGET_BUILD_VARIANT),user)
   LOCAL_CFLAGS += -DTARGET_BUILD_VARIANT_USER
endif

LOCAL_LDFLAGS += -Wl,--export-dynamic

## Includes
LOCAL_C_INCLUDES:= $(LOCAL_PATH)/platform_lib_abstractions

LOCAL_MODULE := libgps.utils
LOCAL_MODULE_OWNER := qcom
LOCAL_VENDOR_MODULE := true

LOCAL_MODULE_TAGS := optional

LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libgps.utils_headers
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH) $(LOCAL_PATH)/platform_lib_abstractions

include $(BUILD_HEADER_LIBRARY)

endif # not BUILD_TINY_ANDROID
