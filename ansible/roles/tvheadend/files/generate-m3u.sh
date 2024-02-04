#!/bin/bash
python3 /opt/m3u-epg-editor/m3u-epg-editor-py3.py --json_cfg=/opt/m3u-epg-editor/config.json

perl -pi -e 's/^https\:\/\//pipe\:\/\/\/usr\/local\/bin\/linker.sh\ https\:\/\//g' /var/lib/iptv/output_file.m3u8
