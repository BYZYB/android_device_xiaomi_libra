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

# Update the brightness to meet the requirement from HW
leftvalue=$(getprop permanent.button.bl.leftvalue)
rightvalue=$(getprop permanent.button.bl.rightvalue)

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

chown system.system /sys/class/leds/button-backlight/brightness
chown system.system /sys/class/leds/button-backlight1/brightness

# start_copying_prebuilt_qcril_db
if [ -f /system/vendor/qcril.db -a ! -f /data/misc/radio/qcril.db ]; then
    cp /system/vendor/qcril.db /data/misc/radio/qcril.db
    chown radio.radio /data/misc/radio/qcril.db
fi

# start_msm_irqbalance
if [ -f /vendor/bin/msm_irqbalance ]; then
    start msm_irqbalance
fi

# Make modem config folder and copy firmware config to that folder
cur_version_info=$(cat /firmware/verinfo/ver_info.txt)

if [ -f /data/misc/radio/ver_info.txt ]; then
    prev_version_info=$(cat /data/misc/radio/ver_info.txt)
else
    prev_version_info=""
fi

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
