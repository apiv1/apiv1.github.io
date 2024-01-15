#!/bin/sh

docker run -d -p 5554-5555:5554-5555 -p 6080:6080 -e EMULATOR_DEVICE="Samsung Galaxy S10" -e WEB_VNC=true --device /dev/kvm --privileged -v docker-android:/root/.android/ -v docker-android-emulator:/root/android_emulator --name android-container budtmo/docker-android:emulator_13.0