#!/bin/bash

settings() {
    echo ""
    echo "Configuration:"
    echo ""

    echo lidarr_eventtype "$lidarr_eventtype"
    echo lidarr_artist_id "$lidarr_artist_id"
    echo lidarr_artist_name "$lidarr_artist_name"
    echo lidarr_artist_path "$lidarr_artist_path"
    echo lidarr_artist_mbid "$lidarr_artist_mbid"
    echo lidarr_artist_type "$lidarr_artist_type"
    echo lidarr_album_id "$lidarr_album_id"
    echo lidarr_album_title "$lidarr_album_title"
    echo lidarr_album_mbid "$lidarr_album_mbid"
    echo lidarr_albumrelease_mbid "$lidarr_albumrelease_mbid"
    echo lidarr_album_releasedate "$lidarr_album_releasedate"
    echo lidarr_download_client "$lidarr_download_client"
    echo lidarr_download_id "$lidarr_download_id"
    echo lidarr_addedtrackpaths "$lidarr_addedtrackpaths"
    echo lidarr_deletedpaths "$lidarr_deletedpaths"
}

# check https://github.com/magne4000/ffmpeg-http-service
dl() {
    d=$(dirname "$1")
    cd $d
	ffmpeg -i $1 -sample_fmt s16p -ar 44100 -vn -acodec alac ${1%.flac}.m4a
}

conversion() {
    IFS='|'
    filesarray=($lidarr_addedtrackpaths)
    converttrackcount=${#filesarray[*]}
    echo ""
    echo "Converting: $converttrackcount Tracks (Target Format: M4A)"
    for fname in "${filesarray[@]}"; do
        filename="$(basename "${fname%.flac}")"
        if [[ $fname == *.flac ]]; then
            dl "$fname"
            echo "Converted: $filename"
            if [ -f "${fname%.flac}.m4a" ]; then
                rm "$fname"
            fi
        else
            echo "Skipping: $filename"
        fi
    done
}

#============START SCRIPT============

settings

if [ "${lidarr_eventtype}" = Test ]; then
    exit 0
fi

conversion

echo ""
echo "AUDIO POST-PROCESSING COMPLETE" && exit 0
