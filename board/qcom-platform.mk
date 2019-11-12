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

# Disk cryption
TARGET_HW_DISK_ENCRYPTION := true

# Hardware
BOARD_USES_QCOM_HARDWARE := true

# Init
TARGET_INIT_VENDOR_LIB := libinit_msm

# Keymaster
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# Peripheral manager
TARGET_PER_MGR_ENABLED := true

# Power
TARGET_POWERHAL_VARIANT := none

# Recovery
TARGET_RECOVERY_DEVICE_MODULES := libinit_msm

# RIL
TARGET_RIL_VARIANT := caf

# Time services
BOARD_USES_QC_TIME_SERVICES := true
