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

target=`getprop ro.board.platform`

case "$target" in "msm8992")
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
		echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
		echo 1440000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo "80 580000:59 680000:54 780000:63 880000:85 1180000:98 1280000:94" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo "98000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo 95 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo 1180000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo 38000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo 380000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo 250000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration

		# Configure governor settings for big cluster
		echo 384000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
		echo 1824000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
		echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
		echo "80 480000:44 580000:65 680000:61 780000:20 880000:90 1180000:74 1280000:98" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo "78000 1280000:38000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo 98 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo 1180000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo 78000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo 380000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
		echo 125000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration

		# Enable thermal and bcl hotplug
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
		echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
		echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
		echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
		echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
		echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

		# Set b.L scheduler parameters
		echo 1 > /proc/sys/kernel/sched_migration_fixup
		echo 30 > /proc/sys/kernel/sched_small_task
		echo 20 > /proc/sys/kernel/sched_mostly_idle_load
		echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run
		echo 99 > /proc/sys/kernel/sched_upmigrate
		echo 85 > /proc/sys/kernel/sched_downmigrate
		echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
		echo 400000 > /proc/sys/kernel/sched_freq_dec_notify

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

		# Enable sched_boost
		echo 1 > /proc/sys/kernel/sched_boost

		# Set Memory parameters
		echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
    ;;
esac

case "$target" in "msm8994")
        # enable suspend trace
        echo 1 > /proc/suspend_trace_stats
        # ensure at most one A57 is online when thermal hotplug is disabled
        echo 0 > /sys/devices/system/cpu/cpu5/online
        echo 0 > /sys/devices/system/cpu/cpu6/online
        echo 0 > /sys/devices/system/cpu/cpu7/online
        # Limit A57 max freq from msm_perf module in case CPU 4 is offline
        echo "4:960000 5:960000 6:960000 7:960000" > /sys/module/msm_performance/parameters/cpu_max_freq
        # disable thermal bcl hotplug to switch governor
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
        for low_threshold_ua in /sys/devices/soc.0/qcom,bcl.*/low_threshold_ua
        do
            echo "50000" > $low_threshold_ua
        done
        for high_threshold_ua in /sys/devices/soc.0/qcom,bcl.*/high_threshold_ua
        do
            echo "4200000" > $high_threshold_ua
        done
        for vph_low_thresh_uv in /sys/devices/soc.0/qcom,bcl.*/vph_low_thresh_uv
        do
            echo "3300000" > $vph_low_thresh_uv
        done
        for vph_high_thresh_uv in /sys/devices/soc.0/qcom,bcl.*/vph_high_thresh_uv
        do
            echo "4300000" > $vph_high_thresh_uv
        done
        # configure governor settings for little cluster
        echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
        echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
        echo 19000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
        echo 90 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
        echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
        echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
        echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
        echo 80 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
        echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
        echo 80000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
        echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        # online CPU4
        echo 1 > /sys/devices/system/cpu/cpu4/online
        # configure governor settings for big cluster
        echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
        echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
        echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
        echo "19000 1400000:39000 1700000:19000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
        echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
        echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
        echo 1248000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
        echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
        echo "85 1500000:90 1800000:70" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
        echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
        echo 80000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
        echo 384000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
        # insert core_ctl module and use conservative paremeters
        insmod /system/lib/modules/core_ctl.ko
        # re-enable thermal and BCL hotplug
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
        # enable LPM
        echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
        # Restore CPU 4 max freq from msm_performance
        echo "4:4294967295 5:4294967295 6:4294967295 7:4294967295" > /sys/module/msm_performance/parameters/cpu_max_freq
        # input boost configuration
        echo 0:1344000 > /sys/module/cpu_boost/parameters/input_boost_freq
        echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
        # configure core_ctl module parameters
        echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
        echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
        echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
        echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
        echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres
        # Setting b.L scheduler parameters
        echo 1 > /proc/sys/kernel/power_aware_timer_migration
        echo 1 > /proc/sys/kernel/sched_migration_fixup
        echo 30 > /proc/sys/kernel/sched_small_task
        echo 20 > /proc/sys/kernel/sched_mostly_idle_load
        echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run
        echo 95 > /proc/sys/kernel/sched_upmigrate
        echo 85 > /proc/sys/kernel/sched_downmigrate
        echo 2 > /proc/sys/kernel/sched_window_stats_policy
        echo 5 > /proc/sys/kernel/sched_ravg_hist_size
        # android background processes are set to nice 10. Never schedule these on the a57s.
        echo 9 > /proc/sys/kernel/sched_upmigrate_min_nice

        for i in cpu0 cpu1 cpu2 cpu3 cpu4 cpu5 cpu6 cpu7
        do
            echo 20 > /sys/devices/system/cpu/$i/sched_mostly_idle_load
            echo 3 > /sys/devices/system/cpu/$i/sched_mostly_idle_nr_run
        done
        echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
        echo 400000 > /proc/sys/kernel/sched_freq_dec_notify
        echo 0 > /proc/sys/kernel/sched_boost
        #relax access permission for display power consumption
        chown -h system /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
        chown -h system /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
        #enable rps static configuration
        echo 8 >  /sys/class/net/rmnet_ipa0/queues/rx-0/rps_cpus
        for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
        do
            echo "bw_hwmon" > $devfreq_gov
            for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
            do
                echo 20 > $cpu_io_percent
            done
            for cpu_guard_band in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/guard_band_mbps
            do
                echo 30 > $cpu_guard_band
            done
        done
        for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
        do
            echo "cpufreq" > $devfreq_gov
        done
        # change GPU initial power level from 305MHz(level 4) to 180MHz(level 5) for power savings
        echo 5 > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
    ;;
esac

rm /data/system/perfd/default_values
setprop ro.min_freq_0 384000
setprop ro.min_freq_4 384000
start perfd

# Let kernel know our image version/variant/crm_version
image_version="10:"
image_version+=`getprop ro.build.id`
image_version+=":"
image_version+=`getprop ro.build.version.incremental`
image_variant=`getprop ro.product.name`
image_variant+="-"
image_variant+=`getprop ro.build.type`
oem_version