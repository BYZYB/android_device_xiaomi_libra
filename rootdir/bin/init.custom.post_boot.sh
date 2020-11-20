#!/vendor/bin/sh
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
rm -rf /data/ss
rm -rf /data/ssh
rm -rf /data/system/dropbox
rm -rf /data/system/heapdump
rm -rf /data/system/perfd
rm -rf /data/thermal
rm -rf /data/tombstones
rm -rf /data/vendor/tombstones

# Remove useless files
find /data/data/com.tencent.mm/MicroMsg/*/appbrand/* -mtime +3 -exec rm -rf {} \;
find /data/data/com.tencent.mm/MicroMsg/*/avatar/* -mtime +3 -exec rm -rf {} \;
find /data/data/com.tencent.mm/MicroMsg/appbrand/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/Android/data/com.tencent.mm/MicroMsg/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/Android/data/com.tencent.mm/MicroMsg/*/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MobileQQ*/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MobileQQ*/*/*/* -mtime +3 -exec rm -rf {} \;
rm -f /data/system/uiderrors.txt
rm -rf /cache/*.*
rm -rf /cache/recovery/*
rm -rf /data/backup/pending/*
rm -rf /data/data/*/app_webview_*
rm -rf /data/data/*/app_webview*/*/*/CacheStorage/*
rm -rf /data/data/*/app_webview*/*/*/ScriptCache/*
rm -rf /data/data/*/cache/*
rm -rf /data/data/*/code_cache/*
rm -rf /data/data/com.microsoft.office*/files/Microsoft/Office/*/*
rm -rf /data/data/com.microsoft.office*/files/temp*/*
rm -rf /data/local/tmp/*
rm -rf /data/media/0/Pictures/.thumbnails/*
rm -rf /data/user_de/*/*/cache/*
rm -rf /data/user_de/*/*/code_cache/*

# Enable ADB root when needed
if [ $(cat /data/adbroot/enabled) -gt 0 ]; then
    setprop service.adb.root 1
    setprop ctl.restart adbd
fi
