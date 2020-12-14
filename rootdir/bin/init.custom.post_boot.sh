#!/vendor/bin/sh
# Remove useless directories
rm -rf /data/anr /data/lineageos_updates /data/local/traces /data/misc/boottrace /data/misc/gcov /data/misc/perfprofd /data/misc/profman /data/misc/trace /data/misc/update_engine /data/misc/update_engine_log /data/misc/wmtrace /data/nfc /data/ota /data/per_boot /data/rollback /data/rollback-observer /data/ss /data/ssh /data/system/dropbox /data/system/heapdump /data/system/perfd /data/thermal /data/tombstones /data/vendor/tombstones

# Remove useless files
find /data/data/com.tencent.mm/MicroMsg/*/appbrand/* -mtime +3 -exec rm -rf {} \;
find /data/data/com.tencent.mm/MicroMsg/*/avatar/* -mtime +3 -exec rm -rf {} \;
find /data/data/com.tencent.mm/MicroMsg/*/image*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/Android/data/com.tencent.mm/MicroMsg/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MobileQQ*/*/* -mtime +3 -exec rm -rf {} \;
find /data/media/0/tencent/MobileQQ*/*/*/* -mtime +3 -exec rm -rf {} \;
rm -rf /data/backup/pending/* /data/data/*/app_webview_* /data/data/*/app_webview*/*/*/CacheStorage/* /data/data/*/app_webview*/*/*/ScriptCache/* /data/data/*/cache/* /data/data/*/code_cache/* /data/data/com.microsoft.office*/files/Microsoft/Office/*/* /data/data/com.microsoft.office*/files/temp*/* /data/local/tmp/* /data/media/0/*/.thumbnails/* /data/media/0/Android/data/*/cache/* /data/system/uiderrors.txt /data/user_de/*/*/cache/* /data/user_de/*/*/code_cache/*

# Enable SELinux when root access is disabled
if [ $(getprop persist.sys.root_access) -le 0 ]; then
    setenforce 1
fi
