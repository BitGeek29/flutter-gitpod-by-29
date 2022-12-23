FROM gitpod/workspace-full:latest

LABEL maintainer="shaikhhaseeb301@gmail.com"

# Install your tools here
SHELL [ "/bin/bash","-c" ]

ENV DEV_TOOLS="$HOME/DevTools"
ENV JAVA_HOME="$DEV_TOOLS/JDK/jdk-11.0.17+8"
ENV ANDROID_HOME="$DEV_TOOLS/Android"
ENV export JAVA_HOME
ENV export ANDROID_HOME
ENV PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

USER root

RUN apt-get update -y
RUN apt-get install -y gcc make build-essential wget curl unzip apt-utils xz-utils libkrb5-dev gradle libpulse0 android-tools-adb android-tools-fastboot
RUN apt remove --purge openjdk-*-jdk

# Install JDK
RUN mkdir -p $DEV_TOOLS/JDK
RUN wget -O $DEV_TOOLS/JDK/jdk-11.0.17_linux-x64_bin.tar.gz https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.9_linux-x64_bin.tar.gz
RUN tar -xvf $DEV_TOOLS/JDK/jdk-11.0.17_linux-x64_bin.tar.gz -C $DEV_TOOLS/JDK
RUN rm $DEV_TOOLS/JDK/jdk-11.0.17_linux-x64_bin.tar.gz

# Install Firebase CLI
RUN npm install -g firebase-tools
RUN dart pub global activate firebase_tools

# Install BREW
RUN mkdir -p $DEV_TOOLS/BREW
RUN wget -O $DEV_TOOLS/BREW/install.sh https://raw.githubusercontent.com/Homebrew/install/master/install.sh
RUN chmod +x $DEV_TOOLS/BREW/install.sh
RUN $DEV_TOOLS/BREW/install.sh

# Install FVM with BREW
RUN brew tap leoafarias/fvm
RUN brew install fvm

USER gitpod
# Install Android SDK
RUN mkdir -p $DEV_TOOLS/Android/cmdline-tools
RUN wget -O $DEV_TOOLS/Android/cmdline-tools/tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN unzip $DEV_TOOLS/Android/cmdline-tools/tools.zip -d $DEV_TOOLS/Android/cmdline-tools
RUN rm $DEV_TOOLS/Android/cmdline-tools/tools.zip

RUN yes | sdkmanager "platform-tools" "platforms;android-33" "build-tools;30.0.3" "extras;android;m2repository" "extras;google;m2repository" "extras;google;google_play_services"

# Install Flutter
RUN cd $GITPOD_REPO_ROOT
RUN fvm install 
RUN fvm use global
RUN fvm flutter config --android-sdk $ANDROID_HOME
RUN yes | fvm flutter doctor --android-licenses
RUN fv flutter doctor