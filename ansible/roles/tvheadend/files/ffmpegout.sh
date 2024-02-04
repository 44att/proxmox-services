#!/bin/bash

/usr/local/bin/ffmpeg -hide_banner -init_hw_device cuda=cu:0 -hwaccel cuda -filter_hw_device cu -hwaccel_output_format cuda -flags -global_header -color_primaries bt2020 -color_trc smpte2084 -colorspace bt2020nc -nostats -follow 1 -err_detect ignore_err -i /home/hts/dump.$1.stream -c:a aac -c:v hevc_nvenc -profile:v main10 -preset slow -qp 25 -b:v 12M -map 0 -f mpegts pipe:1
