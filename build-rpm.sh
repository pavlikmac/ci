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
sudo zypper in -y kmod 
#sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R chmod 777 /boot

sdk-assistant list

cd $ANDROID_ROOT
rpm/dhd/helpers/build_packages.sh -d


# we do not build gst-droid and gmp-droid, skip them
#sed -i 's/buildmw -u\ \"https\:\/\/github.com\/sailfishos\/gst-droid.git\"/echo skip/g' rpm/dhd/helpers/build_packages.sh 
#sed -i 's/buildmw -u\ \"https\:\/\/github.com\/sailfishos\/gmp-droid.git\"/echo skip/g' rpm/dhd/helpers/build_packages.sh 
rpm/dhd/helpers/build_packages.sh -g

cat $ANDROID_ROOT/droid-hal-$DEVICE.log
