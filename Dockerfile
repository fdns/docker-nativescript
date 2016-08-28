FROM ubuntu:14.04

MAINTAINER Felipe Espinoza "faespino@dcc.uchile.cl"

# Install java8
RUN apt-get update && apt-get install -y software-properties-common && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN add-apt-repository -y ppa:webupd8team/java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get install -y oracle-java8-installer && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Android SDK
RUN curl http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz | tar xz -C /opt/

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install sdk elements
RUN echo y | android update sdk --all --no-ui --filter tools
RUN echo y | android update sdk --all --no-ui --filter platform-tools
RUN ( while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --all --no-ui --filter build-tools-23.0.3,android-23,extra-android-m2repository,extra-android-support

RUN which adb
RUN which android

# Create emulator
#RUN echo "no" | android create avd \
#                --force \
#                --device "Nexus 5" \
#                --name test \
#                --target android-24 \
#                --abi armeabi-v7a \
#                --skin WVGA800 \
#                --sdcard 512M

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && apt-get install -y nodejs && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install nativescript
RUN npm install nativescript -g --unsafe-perm

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace