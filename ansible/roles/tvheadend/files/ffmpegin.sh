#!/bin/bash

while [ 1 ]; do
/usr/local/bin/ffmpeg -user_agent Kodi/18 -nostats -reconnect 1 -reconnect_on_network_error 1 -reconnect_on_http_error 1 -reconnect_streamed 1 -reconnect_delay_max 4294 -fflags nobuffer -err_detect ignore_err -i $1 -c copy -map 0 -f mpegts pipe:1 1> /home/hts/dump.$2.stream
done
