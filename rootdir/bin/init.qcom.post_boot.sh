#!/vendor/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Ensure at most two A57 is online when thermal hotplug is disabled
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online

# Enable LPM sleep
echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

# Disable thermal and bcl hotplug
echo 0 > /sys/module/msm_thermal/core_control/enabled
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n disable > $mode
done
for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
do
    bcl_hotplug_mask=`cat $hotplug_mask`
    echo 0 > $hotplug_mask
done
for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
do
    bcl_soc_hotplug_mask=`cat $hotplug_soc_mask`
    echo 0 > $hotplug_soc_mask
done
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n enable > $mode
done

# Disable CPU retention
echo 0 > /sys/module/lpm_levels/system/a53/cpu0/retention/idle_enabled
echo 0 > /sys/module/lpm_levels/system/a53/cpu1/retention/idle_enabled
echo 0 > /sys/module/lpm_levels/system/a53/cpu2/retention/idle_enabled
echo 0 > /sys/module/lpm_levels/system/a53/cpu3/retention/idle_enabled
echo 0 > /sys/module/lpm_levels/system/a57/cpu4/retention/idle_enabled
echo 0 > /sys/module/lpm_levels/system/a57/cpu5/retention/idle_enabled

# Disable L2 retention
echo 0 > /sys/module/lpm_levels/system/a53/a53-l2-retention/idle_enabled
echo 0 > /sys/module/lpm_levels/system/a57/a57-l2-retention/idle_enabled

# Configure governor settings for little cluster
echo 302400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1632000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "sched" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Configure governor settings for big cluster
echo 302400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 1824000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo "sched" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor

# Re-enable thermal and bcl hotplug
echo 1 > /sys/module/msm_thermal/core_control/enabled
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n disable > $mode
done
for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
do
    echo $bcl_hotplug_mask > $hotplug_mask
done
for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
do
    echo $bcl_soc_hotplug_mask > $hotplug_soc_mask
done
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n enable > $mode
done

# Set core_ctl module parameters
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus

# Enable rps static configuration
echo 8 >  /sys/class/net/rmnet_ipa0/queues/rx-0/rps_cpus

# Set GPU governors
for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
do
    echo "bw_hwmon" > $devfreq_gov
done
for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
do
    echo "cpufreq" > $devfreq_gov
done

# Some files in /sys/devices/system/cpu are created after the restorecon of
# /sys/. These files receive the default label "sysfs".
# Restorecon again to give new files the correct label.
restorecon -R /sys/devices/system/cpu

# Relax access permission for display power consumption
chown -h system /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
chown -h system /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
chown -h system /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
chown -h system /sys/devices/system/cpu/cpu4/core_ctl/max_cpus

# Set GPU default power level to 7 (64MHz)
echo 7 > /sys/class/kgsl/kgsl-3d0/default_pwrlevel

# Strar perfd
rm /data/system/perfd/default_values
start perfd

# Let kernel know our image version/variant/crm_version
image_version="10:"
image_version+=`getprop ro.build.id`
image_version+=":"
image_version+=`getprop ro.build.version.incremental`
image_variant=`getprop ro.product.name`
image_variant+="-"
image_variant+=`getprop ro.build.type`
oem_version=`getprop ro.build.version.codename`
echo 10 > /sys/devices/soc0/select_image
echo $image_version > /sys/devices/soc0/image_version
echo $image_variant > /sys/devices/soc0/image_variant
echo $oem_version > /sys/devices/soc0/image_crm_version

# Wait for other boot process
sleep 5

# Remove useless directories
rm -rf /data/anr
rm -rf /data/lineageos_updates
rm -rf /data/local/traces
rm -rf /data/misc/boottrace
rm -rf /data/misc/gcov
rm -rf /data/misc/perfprofd
rm -rf /data/misc/profman
rm -rf /data/misc/trace
rm -rf /data/misc/update_engine
rm -rf /data/misc/update_engine_log
rm -rf /data/misc/wmtrace
rm -rf /data/nfc
rm -rf /data/ota
rm -rf /data/ota_package
rm -rf /data/ss
rm -rf /data/ssh
rm -rf /data/system/dropbox
rm -rf /data/system/heapdump
rm -rf /data/tombstones
rm -rf /data/vendor/tombstones

# Remove useless files
find /data/data/com.tencent.mm/MicroMsg/*/appbrand/* -mtime +3 -exec rm -rf {} \;
find /data/data/com.tencent.mm/MicroMsg/*/avatar/* -mtime +3 -exec rm -rf {} \;
find /data/data/com.tencent.mm/MicroMsg/appbrand/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/Android/data/com.tencent.mm/MicroMsg/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MicroMsg/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MicroMsg/*/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MobileQQi/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MobileQQi/*/*/* -mtime +3 -exec rm -rf {} \;
rm -f /data/system/uiderrors.txt
rm -rf /cache/*.*
rm -rf /cache/recovery/*
rm -rf /data/backup/pending/*
rm -rf /data/data/*/app_webview*/*/CacheStorage/*
rm -rf /data/data/*/app_webview*/*/ScriptCache/*
rm -rf /data/data/*/cache/*
rm -rf /data/data/*/code_cache/*
rm -rf /data/data/com.microsoft.office*/files/Microsoft/Office/*/*
rm -rf /data/data/com.microsoft.office*/files/temp/*
rm -rf /data/data/com.microsoft.office*/files/tempOffice/*
rm -rf /data/local/tmp/*
rm -rf /data/media/0/Pictures/.thumbnails/*
rm -rf /data/user_de/*/*/cache/*
rm -rf /data/user_de/*/*/code_cache/*

# Do fstrim for all partitions
for path in /*;
do
/system/xbin/busybox fstrim -v $path;
done

# Disable ADB after boot
/system/bin/cmd settings put global adb_enabled 0
