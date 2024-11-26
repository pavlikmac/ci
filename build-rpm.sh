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

git clone https://github.com/mer-hybris/geoclue-providers-hybris $ANDROID_ROOT/hybirs/mw/geoclue-providers-hybris
cd $ANDROID_ROOT/hybirs/mw/geoclue-providers-hybris
git checkout 0.2.35

sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R zypper in -y ccache

cd $ANDROID_ROOT/rpm/dhd/helpers
cp /home/mersdk/work/ci/ci/helpers/build_packages.sh .
chmod +x build_packages.sh 

cd $ANDROID_ROOT

#hack too
mkdir -p /home/mersdk/work/ci/ci/hadk_14.1/hybris/droid-configs/installroot/usr/share/kickstarts/
cp /home/mersdk/work/ci/Jolla-@RELEASE@-vince-@ARCH@.ks /home/mersdk/work/ci/ci/hadk_14.1/hybris/droid-configs/installroot/usr/share/kickstarts/ || true
cp /home/mersdk/work/ci/ci/Jolla-@RELEASE@-vince-@ARCH@.ks /home/mersdk/work/ci/ci/hadk_14.1/hybris/droid-configs/installroot/usr/share/kickstarts/ || true #who is the real path

sudo mkdir -p /proc/sys/fs/binfmt_misc/
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
rpm/dhd/helpers/build_packages.sh
