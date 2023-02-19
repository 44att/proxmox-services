#!/bin/bash
while inotifywait /Homepage-data/*; do
    rsync -azq /Homepage-data/ /opt/homepage/config
    chown -R homepage:homepage /opt/homepage/config
done
