#!/bin/bash

pid=$$
echo "main pid is $pid" | logger -t ffmpeg-linker

trap 'echo "Caught trap, ffmpegin.sh pid is $PID"  | logger -t ffmpeg-linker && rm -f /home/hts/dump.$pid.stream && trap - SIGTERM && kill -- -$$ | logger -t ffmpeg-linker' EXIT SIGINT SIGTERM

rm -f /home/hts/dump.$pid.stream

mkfifo /home/hts/dump.$pid.stream

/usr/local/bin/ffmpegin.sh $1 $pid & PID=$!
echo "ffmpegin.sh pid is $PID" | logger -t ffmpeg-linker

/usr/local/bin/ffmpegout.sh $pid

rm -f /home/hts/dump.$pid.stream
