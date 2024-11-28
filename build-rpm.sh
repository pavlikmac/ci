#!/bin/bash

set -x

source /home/mersdk/work/ci/ci/hadk.env
export ANDROID_ROOT=/home/mersdk/work/ci/ci/hadk_14.1

sudo chown -R mersdk:mersdk $ANDROID_ROOT
cd $ANDROID_ROOT

cd ~/.scratchbox2
cp -R SailfishOS-*-$PORT_ARCH $VENDOR-$DEVICE-$PORT_ARCH
cd $VENDOR-$DEVICE-$PORT_ARCH
sed -i "s/SailfishOS-$SAILFISH_VERSION/$VENDOR-$DEVICE/g" sb2.config
sudo ln -s /srv/mer/targets/SailfishOS-$SAILFISH_VERSION-$PORT_ARCH /srv/mer/targets/$VENDOR-$DEVICE-$PORT_ARCH
sudo ln -s /srv/mer/toolings/SailfishOS-$SAILFISH_VERSION /srv/mer/toolings/$VENDOR-$DEVICE

# 3.3.0.16 hack
sudo zypper in -y kmod ccache
#sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R chmod 777 /boot

sdk-assistant list

cd $ANDROID_ROOT
sed -i '/CONFIG_NETFILTER_XT_MATCH_QTAGUID/d' hybris/mer-kernel-check/mer_verify_kernel_config

sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R zypper in -y ccache

cd $ANDROID_ROOT
cp /home/mersdk/work/ci/ci/helpers/build_packages.sh rpm/dhd/helpers/
chmod +x rpm/dhd/helpers/build_packages.sh 

cd $ANDROID_ROOT
# move it to here
# Add vince lost libs
cp device/xiaomi/vince/lostlibs/*.so out/target/product/vince/system/lib/

sudo mkdir -p /proc/sys/fs/binfmt_misc/
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
rpm/dhd/helpers/build_packages.sh

if [ "$?" -ne 0 ];then
  # if failed, retry once
  rpm/dhd/helpers/build_packages.sh
  cat $ANDROID_ROOT/droid-hal-vince.log
fi
