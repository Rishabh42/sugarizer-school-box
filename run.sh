#!/bin/bash

#Checking for root permissions
if [ "$(id -u)" -ne "0" ] ; then
  echo "error: this script must be executed with root privileges!"
  exit 1
fi

echo "Starting Script"

if [ -d "build" ]; then
 rm -r build
fi

git clone https://github.com/drtyhlpr/rpi23-gen-image.git build/

if [ ! -d "docker-images" ]; then
 mkdir docker-images
 cd docker-images
 wget -O mongodb.docker https://www.dropbox.com/s/aojfspk66a8z1an/mongodb.docker?dl=0
 wget -O node.docker https://www.dropbox.com/s/4p5cnkt9id0qs17/node.docker?dl=0
 cd ..
fi


cd build

if [ ! -d "custom.d" ]; then
  mkdir custom.d
fi
 

#Copying Scripts from ./scripts to /build/custom.d
find ../scripts -type f -name \* -exec cp {} ./custom.d/ \;

#Copying .deb packages
if [ ! -d "packages" ]; then
  mkdir packages
fi

cp -r ../packages/* ./packages/ 

#Copying Templates
cp -r ../templates .

#Starting the Build Script
CONFIG_TEMPLATE="rpi3stretch-sugarizer" ./rpi*

cd ..

mv build/images .


