#!/bin/bash

cd /opt/ffmpeg

PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure --enable-openssl --enable-cuda-nvcc --enable-cuda --enable-cuvid --enable-nvenc --enable-gpl --enable-nonfree --enable-libx264 --enable-libfreetype --enable-libfdk-aac --enable-libnpp --extra-cflags="-I /usr/local/cuda/include" --extra-ldflags="-L /usr/local/cuda/lib64"

make -j$(nproc)

make install
