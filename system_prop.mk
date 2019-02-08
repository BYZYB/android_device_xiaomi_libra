# Dalvik heap
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m \
    pm.dexopt.install=speed \
    pm.dexopt.bg-dexopt=speed \
    pm.dexopt.boot=speed \
    pm.dexopt.first-boot=speed \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.image-dex2oat-filter=speed

PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    rild.libargs=-d[SPACE]/dev/smd0 \
    persist.rild.nitz_plmn="" \
    persist.rild.nitz_long_ons_0="" \
    persist.rild.nitz_long_ons_1="" \
    persist.rild.nitz_long_ons_2="" \
    persist.rild.nitz_long_ons_3="" \
    persist.rild.nitz_short_ons_0="" \
    persist.rild.nitz_short_ons_1="" \
    persist.rild.nitz_short_ons_2="" \
    persist.rild.nitz_short_ons_3="" \
    ril.subscription.types=RUIM \
    persist.sys.ssr.restart_level=ALL_ENABLE \
    persist.sys.ssr.enable_ramdumps=0 \
    persist.radio.add_power_save=1 \
    persist.radio.multisim.config=dsds \
    DEVICE_PROVISIONED=1

# Start in TD-SCDMA, GSM/WCDMA and LTE mode
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=20,20 \
    ro.telephony.default_cdma_sub=0

PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.hw=1 \
    debug.egl.hw=1 \
    debug.composition.type=c2d \
    persist.hwc.mdpcomp.enable=true \
    persist.mdpcomp.4k2kSplit=1 \
    persist.mdpcomp_perfhint=60 \
    debug.mdpcomp.logs=0 \
    persist.metadata_dynfps.disable=false \
    persist.hwc.ptor.enable=true \
    dev.pm.dyn_samplingrate=1 \
    persist.demo.hdmirotationlock=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.enable=true \
    persist.vendor.audio.speaker.prot.enable=true

#enable dirac effect for speaker
PRODUCT_PROPERTY_OVERRIDES += \
    persist.audio.dirac.speaker=true

#0 is default(30 min)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.spkr.cal.duration=0 \
    qcom.hw.aac.encoder=true

#
# system props for the cne module
#
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1

#
# system props for the dpm module
#
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dpm.feature=0

PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.enable-player=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-aac=true \
    media.stagefright.enable-qcp=true \
    media.stagefright.enable-fma2dp=true \
    media.stagefright.enable-scan=true \
    mmp.enable.3g2=true \
    mm.enable.smoothstreaming=true \
    media.aac_51_output_enabled=true \
    av.debug.disable.pers.cache=true \

#3379827: Decimal sum after adding WAV parser flag
#37491 is decimal sum of supported codecs in AAL
#codecs: DivX DivXHD AVI AC3 ASF AAC QCP DTS 3G2 MP2TS
PRODUCT_PROPERTY_OVERRIDES += \
    mm.enable.qcom_parser=3379827

# Enable AwesomePlayer stats
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.sf.statistics=0

# Print clip name being played
PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.log-uri=0

# VIDC: debug_levels
# 1:ERROR 2:HIGH 4:LOW 0:NOLOGS 7:AllLOGS
PRODUCT_PROPERTY_OVERRIDES += \
    vidc.debug.level=0

# Additional i/p buffer in case of encoder DCVS
PRODUCT_PROPERTY_OVERRIDES += \
    vidc.enc.dcvs.extra-buff-count=2

#
# system props for the data modules
#
PRODUCT_PROPERTY_OVERRIDES += \
    ro.use_data_netmgrd=true \
    persist.data.netmgrd.qos.enable=true \
    persist.data.mode=concurrent \
    ro.data.large_tcp_window_size=true

#system props for time-services
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

#
# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report major/minor versions as 3/0
# 196609 is decimal for 0x30001 to report major/minor versions as 3/1
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

# System property for cabl
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qualcomm.cabl=0

# System property for AD
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qcom.ad=1 \
    ro.qcom.ad.calib.data=/system/etc/calib.cfg \
    ro.qcom.ad.sensortype=2

# Display feature support
# bit0-ColorPrefer bit1-EyeCare bit2-AD bit3-CE bit4-CABC bit5-SRGB

#
# System props for telephony
# System prop to turn on CdmaLTEPhone always
PRODUCT_PROPERTY_OVERRIDES += \
    telephony.lteOnCdmaDevice=1

#
# System props for bluetooth
# System prop to turn on hfp client
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.hfp.client=1 \
    ro.bt.bdaddr_path=/data/misc/bluetooth/bdaddr \
    ro.qualcomm.bluetooth.opp=true \
    ro.qualcomm.bluetooth.hfp=true \
    ro.qualcomm.bluetooth.hsp=true \
    ro.qualcomm.bluetooth.pbap=true \
    ro.qualcomm.bluetooth.ftp=true \
    ro.qualcomm.bluetooth.nap=true \
    ro.bluetooth.sap=true \
    ro.bluetooth.dun=true \
    ro.qualcomm.bluetooth.map=true \
    ro.bluetooth.hfp.ver=1.6

# Set Bluetooth transport
# initialization timeout
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.enable_timeout_ms=12000

#Simulate sdcard on /data/media
#
PRODUCT_PROPERTY_OVERRIDES += \
    persist.fuse_sdcard=true

#system prop for Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=rome

#system prop for wipower support
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.wipower=true

#Set this true as ROME which is programmed
#as embedded wipower mode by deafult
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.emb_wp_mode=true

#
#snapdragon value add features
#
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.audio.sdk.ssr=false \
    persist.audio.ssr.3mic=false

##fluencetype can be "fluence" or "fluencepro" or "none"
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.audio.sdk.fluencetype=fluence \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.vendor.audio.fluence.speaker=true \
    ro.config.media_vol_steps=25 \
    ro.config.vc_call_vol_steps=7

PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.sensors.gestures=true \
    ro.qc.sdk.gestures.camera=false \
    ro.qc.sdk.camera.facialproc=false

#property to enable user to access Google WFD settings.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.wfd.enable=1

#property to choose between virtual/external wfd display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.virtual=0 \
    vendor.audio.tunnel.encode=false

#enable gapless by default
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.gapless.enabled=true

#Buffer size in kbytes for compress offload playback
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.buffer.size.kb=32

#Enable offload audio video playback by default
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.video=true

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.offload.multiple.enabled=false

#Enable audio track offload by default
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.track.enable=false

#Enable music through deep buffer
PRODUCT_PROPERTY_OVERRIDES += \
    audio.deep_buffer.media=true

#property to enable VDS WFD solution
PRODUCT_PROPERTY_OVERRIDES += \
    persist.hwc.enable_vds=1

#enable voice path for PCM VoIP by default
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.voice.path.for.pcm.voip=true

#selects CoreSight configuration to enable
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.coresight.config=stm-events

# Enable manual network selection function and distinguish 2G/3G/4G
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.rat_on=combine

#For specail cdma card sms issue
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.force_on_dc=true

#Enable short oos enhancement
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.oosenhance.enable=true \
    ro.sys.oosenhance.timer=20000

# button jack mode & switch
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.button_jack_profile=volume \
    persist.sys.button_jack_switch=0

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.mcd_config_file=/system/etc/mcd_default.conf \
    persist.sys.klo=on \
    persist.sys.whetstone.level=2 \
    persist.sys.frozenKernel=true \
    ro.carrier=unknown \
    ro.vendor.extension_library=libqti-perfd-client.so \
    persist.radio.custom_ecc=1 \
    persist.radio.sib16_support=1 \
    ro.frp.pst=/dev/block/bootdevice/by-name/config \
    af.fast_track_multiplier=1 \
    vendor.audio_hal.period_size=192 \
    ro.btconfig.if=uart \
    ro.btconfig.dev=/dev/ttyHS0 \
    ro.btconfig.vendor=qcom \
    ro.btconfig.chip=QCA6164 \
    persist.power.useautobrightadj=true \
