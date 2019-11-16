# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio.deep_buffer.media=true \
    audio.offload.disable=0 \
    audio.offload.pcm.16bit.enable=true \
    audio.offload.pcm.24bit.enable=true \
    audio.offload.track.enable=false \
    audio.offload.video=true \
    persist.audio.dirac.speaker=true \
    persist.audio.ssr.3mic=false \
    persist.vendor.audio.fluence.speaker=true \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=true \
    persist.vendor.audio.spkr.cal.duration=0 \
    qcom.hw.aac.encoder=true \
    ro.vendor.audio.sdk.fluencetype=fluence \
    ro.vendor.audio.sdk.ssr=false \
    vendor.audio_hal.period_size=192 \
    vendor.audio.offload.buffer.size.kb=32 \
    vendor.audio.offload.gapless.enabled=true \
    vendor.audio.offload.multiple.enabled=false \
    vendor.voice.path.for.pcm.voip=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.enable_timeout_ms=12000 \
    bluetooth.hfp.client=1 \
    ro.bluetooth.dun=true \
    ro.bluetooth.emb_wp_mode=true \
    ro.bluetooth.hfp.ver=1.6 \
    ro.bluetooth.sap=true \
    ro.bluetooth.wipower=true \
    ro.bt.bdaddr_path=/data/misc/bluetooth/bdaddr \
    ro.btconfig.chip=QCA6164 \
    ro.btconfig.dev=/dev/ttyHS0 \
    ro.btconfig.if=uart \
    ro.btconfig.vendor=qcom \
    ro.qualcomm.bluetooth.ftp=true \
    ro.qualcomm.bluetooth.hfp=true \
    ro.qualcomm.bluetooth.hsp=true \
    ro.qualcomm.bluetooth.map=true \
    ro.qualcomm.bluetooth.nap=true \
    ro.qualcomm.bluetooth.opp=true \
    ro.qualcomm.bluetooth.pbap=true \
    vendor.qcom.bluetooth.soc=rome

# Button jack
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.button_jack_profile=volume \
    persist.sys.button_jack_switch=0

# Dexpreopt
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.image-dex2oat-filter=speed \
    pm.dexopt.bg-dexopt=speed \
    pm.dexopt.boot=speed \
    pm.dexopt.first-boot=speed \
    pm.dexopt.install=speed

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=480 \
    ro.sys.display.support=23

# Fingerpirnt
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/bootdevice/by-name/config \
    ro.hardware.fingerprint=fpc \
    sys.fpc.tu.disabled=0

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610 \
    ro.surface_flinger.protected_contents=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.max_virtual_display_dimension=2048

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    av.debug.disable.pers.cache=true \
    media.aac_51_output_enabled=true \
    media.stagefright.enable-aac=true \
    media.stagefright.enable-fma2dp=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-player=true \
    media.stagefright.enable-qcp=true \
    media.stagefright.enable-scan=true \
    mm.enable.qcom_parser=3379827 \
    mm.enable.smoothstreaming=true \
    mmp.enable.3g2=true

# Network
PRODUCT_PROPERTY_OVERRIDES += \
    persist.data.mode=concurrent \
    persist.data.netmgrd.qos.enable=true \
    ro.data.large_tcp_window_size=true \
    ro.use_data_netmgrd=true

# OOS enhancements
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.oosenhance.enable=true \
    ro.sys.oosenhance.timer=20000

# Others
PRODUCT_PROPERTY_OVERRIDES += \
    DEVICE_PROVISIONED=1 \
    persist.android.strictmode=0 \
    persist.power.useautobrightadj=true \
    ro.vendor.extension_library=libqti-perfd-client.so

# Qualcomm specifics
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1 \
    persist.dpm.feature=0 \
    ro.qc.sdk.camera.facialproc=false \
    ro.qc.sdk.gestures.camera=false \
    ro.qc.sdk.sensors.gestures=true \
    ro.qcom.ad.sensortype=2 \
    ro.qcom.ad=1 \
    ro.qualcomm.cabl=0 \
    ro.vendor.qti.sys.fw.bservice_enable=true

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.add_power_save=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.custom_ecc=1 \
    persist.radio.force_on_dc=true \
    persist.radio.multisim.config=dsds \
    persist.radio.rat_on=combine \
    persist.radio.sib16_support=1

# Rild
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.ssr.enable_ramdumps=0 \
    persist.sys.ssr.restart_level=modem \
    ril.subscription.types=RUIM \
    rild.libargs=-d[SPACE]/dev/smd0 \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so

# Telephony
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_cdma_sub=0 \
    ro.telephony.default_network=10 \
    telephony.lteOnCdmaDevice=1

# Time services
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

# Video
PRODUCT_PROPERTY_OVERRIDES += \
    debug.composition.type=c2d \
    debug.egl.hw=1 \
    debug.mdpcomp.logs=0 \
    debug.sf.hw=1 \
    dev.pm.dyn_samplingrate=1 \
    persist.demo.hdmirotationlock=false \
    persist.hwc.mdpcomp.enable=true \
    persist.hwc.ptor.enable=true \
    persist.mdpcomp_perfhint=50 \
    persist.mdpcomp.4k2kSplit=1 \
    persist.metadata_dynfps.disable=false \
    persist.vendor.audio.speaker.prot.enable=true \
    ro.hdmi.enable=true \
    vidc.debug.level=0 \
    vidc.enc.dcvs.extra-buff-count=2

# VOLTE
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dbg.ims_volte_enable=1 \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1 \
    persist.dbg.wfc_avail_ovr=1 \
    persist.ims.disableDebugLogs=1 \
    persist.radio.calls.on.ims=1 \
    persist.radio.data_con_rprt=1 \
    persist.radio.data_ltd_sys_ind=1 \
    persist.radio.rat_on=combine \
    persist.volte_enabled_by_hw=1

# Wireless display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.wfd.enable=1 \
    persist.hwc.enable_vds=1 \
    persist.sys.wfd.virtual=0 \
    vendor.audio.tunnel.encode=false
