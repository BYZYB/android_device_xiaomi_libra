[AID_VENDOR_QCOM_DIAG]
value:2950

[AID_VENDOR_RFS]
value:2951

[AID_VENDOR_RFS_SHARED]
value:2952

[vendor/bin/cnss-daemon]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: NET_BIND_SERVICE

[vendor/bin/pm-service]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: NET_BIND_SERVICE

[vendor/bin/wcnss_filter]
mode: 0755
user: AID_BLUETOOTH
group: AID_BLUETOOTH
caps: BLOCK_SUSPEND

[vendor/modem_firmware/image/*]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[bt_firmware/]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[firmware/]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[firmware/image/*]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[persist/]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0
