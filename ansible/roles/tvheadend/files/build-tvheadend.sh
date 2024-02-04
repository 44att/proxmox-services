#!/bin/bash

BASE=$(dirname "$0")
(
  if [ -d "$BASE/tvheadend" ]; then
    cd "$BASE/tvheadend" 
    git pull
  else
    cd "$BASE" 
    git clone https://github.com/tvheadend/tvheadend.git tvheadend # --depth=5 (need version tag workaround else 0.0.0 version)
    cd "$BASE/tvheadend" 
  fi

  python3 /opt/helpers/fix-tvheadend.py

  time AUTOBUILD_CONFIGURE_EXTRA="--python=python3 --disable-bintray_cache --enable-libsystemd_daemon --enable-nonfree --enable-cuda-nvcc --enable-cuda --enable-cuvid --enable-nvenc --enable-gpl --enable-nonfree --enable-libx264 --enable-libfreetype --enable-libfdk-aac --enable-libnpp --extra-cflags=\"-I /usr/local/cuda/include\" --extra-ldflags=\"-L /usr/local/cuda/lib64\" --disable-static --enable-shared --enable-openssl " ./Autobuild.sh -j$(nproc) # edit only betwin "quotation marks" 
) | tee "$BASE/build.log"
