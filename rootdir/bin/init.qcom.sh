#!/vendor/bin/sh
# Copyright (c) 2009-2015, The Linux Foundation. All rights reserved.
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

target=$(getprop ro.board.platform)
if [ -f /sys/devices/soc0/soc_id ]; then
    platformid=$(cat /sys/devices/soc0/soc_id)
else
    platformid=$(cat /sys/devices/system/soc/soc0/id)
fi

start_battery_monitor() {
    if ls /sys/bus/spmi/devices/qpnp-bms-*/fcc_data; then
        chown root.system /sys/module/pm8921_bms/parameters/*
        chown root.system /sys/module/qpnp_bms/parameters/*
        chown root.system /sys/bus/spmi/devices/qpnp-bms-*/fcc_data
        chown root.system /sys/bus/spmi/devices/qpnp-bms-*/fcc_temp
        chown root.system /sys/bus/spmi/devices/qpnp-bms-*/fcc_chgcyl
        chmod 0660 /sys/module/qpnp_bms/parameters/*
        chmod 0660 /sys/module/pm8921_bms/parameters/*
        mkdir -p /data/bms
        chown root.system /data/bms
        chmod 0770 /data/bms
        start battery_monitor
    fi
}

start_charger_monitor() {
    if ls /sys/module/qpnp_charger/parameters/charger_monitor; then
        chown root.system /sys/module/qpnp_charger/parameters/*
        chown root.system /sys/class/power_supply/battery/input_current_max
        chown root.system /sys/class/power_supply/battery/input_current_trim
        chown root.system /sys/class/power_supply/battery/input_current_settled
        chown root.system /sys/class/power_supply/battery/voltage_min
        chmod 0664 /sys/class/power_supply/battery/input_current_max
        chmod 0664 /sys/class/power_supply/battery/input_current_trim
        chmod 0664 /sys/class/power_supply/battery/input_current_settled
        chmod 0664 /sys/class/power_supply/battery/voltage_min
        chmod 0664 /sys/module/qpnp_charger/parameters/charger_monitor
        start charger_monitor
    fi
}

start_vm_bms() {
    if [ -e /dev/vm_bms ]; then
        chown root.system /sys/class/power_supply/bms/current_now
        chown root.system /sys/class/power_supply/bms/voltage_ocv
        chmod 0664 /sys/class/power_supply/bms/current_now
        chmod 0664 /sys/class/power_supply/bms/voltage_ocv
        start vm_bms
    fi
}

start_msm_irqbalance_8939() {
    if [ -f /vendor/bin/msm_irqbalance ]; then
        case "$platformid" in
        "239")
            start msm_irqbalance
            ;;
        esac
    fi
}

start_msm_irqbalance() {
    if [ -f /vendor/bin/msm_irqbalance ]; then
        start msm_irqbalance
    fi
}

start_copying_prebuilt_qcril_db() {
    if [ -f /system/vendor/qcril.db -a ! -f /data/misc/radio/qcril.db ]; then
        cp /system/vendor/qcril.db /data/misc/radio/qcril.db
        chown radio.radio /data/misc/radio/qcril.db
    fi
}

baseband=$(getprop ro.baseband)

case "$baseband" in
"svlte2a")
    start bridgemgrd
    ;;
esac

leftvalue=$(getprop permanent.button.bl.leftvalue)
rightvalue=$(getprop permanent.button.bl.rightvalue)
# update the brightness to meet the requirement from HW
if [ $(getprop ro.boot.hwversion | grep -e 1.[0-9].[0-9]) ]; then
    if [ "$leftvalue" = "" ]; then
        echo 15 >/sys/class/leds/button-backlight1/max_brightness
    else
        echo $leftvalue >/sys/class/leds/button-backlight1/max_brightness
    fi
    if [ "$rightvalue" = "" ]; then
        echo 30 >/sys/class/leds/button-backlight/max_brightness
    else
        echo $rightvalue >/sys/class/leds/button-backlight/max_brightness
    fi
fi

if [ $(getprop ro.boot.hwversion | grep -e 2.[0-9].[0-9]) ]; then
    if [ "$leftvalue" = "" ]; then
        echo 255 >/sys/class/leds/button-backlight1/max_brightness
    else
        echo $leftvalue >/sys/class/leds/button-backlight1/max_brightness
    fi
    if [ "$rightvalue" = "" ]; then
        echo 255 >/sys/class/leds/button-backlight/max_brightness
    else
        echo $rightvalue >/sys/class/leds/button-backlight/max_brightness
    fi
fi

if [ $(getprop ro.boot.hwversion | grep -e [3-4].[0-9].[0-9]) ]; then
    if [ "$leftvalue" = "" ]; then
        echo 80 >/sys/class/leds/button-backlight1/max_brightness
    else
        echo $leftvalue >/sys/class/leds/button-backlight1/max_brightness
    fi
    if [ "$rightvalue" = "" ]; then
        echo 80 >/sys/class/leds/button-backlight/max_brightness
    else
        echo $rightvalue >/sys/class/leds/button-backlight/max_brightness
    fi
fi

chown system.system /sys/class/leds/button-backlight/brightness
chown system.system /sys/class/leds/button-backlight1/brightness

# Update the panel color property
if [ $(getprop ro.boot.hwversion | grep -e [34].*) ]; then
    if [ -f /sys/bus/i2c/devices/2-004a/panel_color ]; then
        # Atmel
        color=$(cat /sys/bus/i2c/devices/2-004a/panel_color)
    elif [ -f /sys/bus/i2c/devices/2-0038/panel_color ]; then
        color=$(cat /sys/bus/i2c/devices/2-0038/panel_color)
    else
        color="0"
    fi

    case "$color" in
    "1")
        setprop sys.panel.color WHITE
        echo 108 >/sys/class/leds/red/max_brightness
        echo 190 >/sys/class/leds/green/max_brightness
        echo 255 >/sys/class/leds/blue/max_brightness
        ;;
    "2")
        setprop sys.panel.color BLACK
        echo 48 >/sys/class/leds/red/max_brightness
        echo 96 >/sys/class/leds/green/max_brightness
        echo 96 >/sys/class/leds/blue/max_brightness
        ;;
    "7")
        setprop sys.panel.color PURPLE
        echo 48 >/sys/class/leds/red/max_brightness
        echo 226 >/sys/class/leds/green/max_brightness
        echo 166 >/sys/class/leds/blue/max_brightness
        ;;
    "8")
        setprop sys.panel.color GOLDEN
        echo 118 >/sys/class/leds/red/max_brightness
        echo 214 >/sys/class/leds/green/max_brightness
        echo 255 >/sys/class/leds/blue/max_brightness
        ;;
    *)
        setprop sys.panel.color UNKNOWN
        ;;
    esac
elif [ $(getprop ro.boot.hwversion | grep -e 2.[0-9].[0-9]) ]; then
    echo 48 >/sys/class/leds/red/max_brightness
    echo 48 >/sys/class/leds/green/max_brightness
    echo 48 >/sys/class/leds/blue/max_brightness
else
    echo 48 >/sys/class/leds/red/max_brightness
    echo 48 >/sys/class/leds/green/max_brightness
    echo 96 >/sys/class/leds/blue/max_brightness
fi

#start_sensors
start_copying_prebuilt_qcril_db

case "$target" in
"msm7630_surf" | "msm7630_1x" | "msm7630_fusion")
    if [ -f /sys/devices/soc0/hw_platform ]; then
        value=$(cat /sys/devices/soc0/hw_platform)
    else
        value=$(cat /sys/devices/system/soc/soc0/hw_platform)
    fi
    case "$value" in
    "Fluid")
        start profiler_daemon
        ;;
    esac
    ;;
"msm8660")
    if [ -f /sys/devices/soc0/hw_platform ]; then
        platformvalue=$(cat /sys/devices/soc0/hw_platform)
    else
        platformvalue=$(cat /sys/devices/system/soc/soc0/hw_platform)
    fi
    case "$platformvalue" in
    "Fluid")
        start profiler_daemon
        ;;
    esac
    ;;
"msm8960")
    case "$baseband" in
    "msm")
        start_battery_monitor
        ;;
    esac

    if [ -f /sys/devices/soc0/hw_platform ]; then
        platformvalue=$(cat /sys/devices/soc0/hw_platform)
    else
        platformvalue=$(cat /sys/devices/system/soc/soc0/hw_platform)
    fi
    case "$platformvalue" in
    "Fluid")
        start profiler_daemon
        ;;
    "Liquid")
        start profiler_daemon
        ;;
    esac
    ;;
"msm8974")
    platformvalue=$(cat /sys/devices/soc0/hw_platform)
    case "$platformvalue" in
    "Fluid")
        start profiler_daemon
        ;;
    "Liquid")
        start profiler_daemon
        ;;
    esac
    case "$baseband" in
    "msm")
        start_battery_monitor
        ;;
    esac
    start_charger_monitor
    ;;
"apq8084")
    platformvalue=$(cat /sys/devices/soc0/hw_platform)
    case "$platformvalue" in
    "Fluid")
        start profiler_daemon
        ;;
    "Liquid")
        start profiler_daemon
        ;;
    esac
    ;;
"msm8226")
    start_charger_monitor
    ;;
"msm8610")
    start_charger_monitor
    ;;
"msm8916")
    start_vm_bms
    start_msm_irqbalance_8939
    if [ -f /sys/devices/soc0/soc_id ]; then
        soc_id=$(cat /sys/devices/soc0/soc_id)
    else
        soc_id=$(cat /sys/devices/system/soc/soc0/id)
    fi

    if [ -f /sys/devices/soc0/platform_subtype_id ]; then
        platform_subtype_id=$(cat /sys/devices/soc0/platform_subtype_id)
    fi
    if [ -f /sys/devices/soc0/hw_platform ]; then
        hw_platform=$(cat /sys/devices/soc0/hw_platform)
    fi
    case "$soc_id" in
    "239")
        case "$hw_platform" in
        "Surf")
            case "$platform_subtype_id" in
            "1")
                setprop qemu.hw.mainkeys 0
                ;;
            esac
            ;;
        "MTP")
            case "$platform_subtype_id" in
            "3")
                setprop qemu.hw.mainkeys 0
                ;;
            esac
            ;;
        esac
        ;;
    esac
    ;;
"msm8994" | "msm8992")
    start_msm_irqbalance
    ;;
"msm8909")
    start_vm_bms
    ;;
esac

bootmode=$(getprop ro.bootmode)
emmc_boot=$(getprop ro.boot.emmc)
case "$emmc_boot" in
"true")
    if [ "$bootmode" != "charger" ]; then # start rmt_storage and rfs_access
        start rmt_storage
        start rfs_access
    fi
    ;;
esac

#
# Make modem config folder and copy firmware config to that folder
#
if [ -f /data/misc/radio/ver_info.txt ]; then
    prev_version_info=$(cat /data/misc/radio/ver_info.txt)
else
    prev_version_info=""
fi

cur_version_info=$(cat /firmware/verinfo/ver_info.txt)
if [ ! -f /firmware/verinfo/ver_info.txt -o "$prev_version_info" != "$cur_version_info" ]; then
    rm -rf /data/misc/radio/modem_config
    mkdir /data/misc/radio/modem_config
    chmod 770 /data/misc/radio/modem_config
    cp -r /firmware/image/modem_pr/mcfg/configs/* /data/misc/radio/modem_config
    chown -R radio.radio /data/misc/radio/modem_config
    cp /firmware/verinfo/ver_info.txt /data/misc/radio/ver_info.txt
    chown radio.radio /data/misc/radio/ver_info.txt
fi
cp /firmware/image/modem_pr/mbn_ota.txt /data/misc/radio/modem_config
chown radio.radio /data/misc/radio/modem_config/mbn_ota.txt
echo 1 >/data/misc/radio/copy_complete
