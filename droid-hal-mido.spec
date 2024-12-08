# These and other macros are documented in dhd/droid-hal-device.inc
%define device mido
%define vendor xiaomi
%define vendor_pretty Xiaomi
%define device_pretty Redmi Note 4
%define installable_zip 1
%define droid_target_aarch64 1
%define android_version_major 7

%define straggler_files \
  /init.qcom.sh \
  /init.qcom.usb.sh \
  /bugreports \
  /d \
  /file_contexts.bin \
  /property_contexts \
  /sdcard \
  /selinux_version \
  /service_contexts \
  /vendor \
%{nil}

%define additional_post_scripts \
/usr/bin/groupadd-user media_rw || :\
%{nil}

%define android_config \
#define WANT_ADRENO_QUIRKS 1\
%{nil}
 
%include rpm/dhd/droid-hal-device.inc