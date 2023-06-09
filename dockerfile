FROM ubuntu:18.04

# Prerequisites

RUN apt update && apt install -y curl unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget sudo git
# Set up new user

WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT="$PATH:/home/developer/Android/sdk"
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv cmdline-tools Android/sdk/cmdline-tools
RUN  yes | /home/developer/Android/sdk/cmdline-tools/bin/sdkmanager --licenses --sdk_root=/home/developer/Android/sdk

RUN  /home/developer/Android/sdk/cmdline-tools/bin/sdkmanager "build-tools;33.0.2" "patcher;v4" "platform-tools" "platforms;android-33" "sources;android-33" --sdk_root=/home/developer/Android/sdk
ENV PATH="$PATH:/home/developer/Android/sdk/platform-tools"
ENV PATH="$PATH:/home/developer/Android/sdk/cmdline-tools/bin"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

#Download TheCommand line Tools And Accept Licences
RUN  sdkmanager "cmdline-tools;latest" --sdk_root=/home/developer/Android/sdk

# Install required emulator packages

RUN  flutter doctor --android-licenses

# Run basic check to download Dark SDK
RUN flutter doctor
RUN flutter precache --android --web
# Run basic check to download Dark SDK
RUN flutter doctor
RUN mkdir test
RUN cd test
RUN flutter create setuping
WORKDIR /home/developer/setuping
RUN flutter build apk --no-shrink --no-android-gradle-daemon
# Copy the entrypoint script
COPY entrypoint.sh /home/developer/entrypoint.sh
RUN chmod +x /home/developer/entrypoint.sh

# Set the entrypoint script as the default command
ENTRYPOINT ["/home/developer/entrypoint.sh"]
