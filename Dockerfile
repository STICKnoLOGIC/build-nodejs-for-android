#https://github.com/sjitech/android-gcc-toolchain/blob/master/Dockerfile
FROM osexp2000/android-gcc-toolchain

ENTRYPOINT []
CMD ["/bin/bash"]

ENV PATH=$PATH:/home/devuser/build-nodejs-for-android

RUN sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
        gcc g++ gcc-multilib g++-multilib \
    && \
    wget -O NDK -q https://dl.google.com/android/repository/android-ndk-r21b-linux-x86_64.zip && \
          sudo apt install unzip -y && \
          unzip -q NDK && export NDK=./NDK && \
    git clone https://github.com/sjitech/build-nodejs-for-android -b master --single-branch && \
    git clone https://github.com/nodejs/node && \
    cd node && \
    ( build-nodejs-for-android v18.12.0 --verbose --compress >/dev/null; : ) && \
    echo "Removing infrequent toolchains" && \
    for ARCH in arm64 x86 x64 mips; do android-gcc-toolchain $ARCH bash -c 'rm -fr "${BIN%/*}"'; done && \
    echo "Done"
