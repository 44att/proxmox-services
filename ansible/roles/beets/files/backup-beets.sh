#!/bin/bash

# backup_beets.sh
#
# Backups up `library.db` from beets.

BEETS_WORKING_DIR="/var/lib/beets"
BACKUP_DIR="/tmp/beets-backups"
FINAL_DIR="/mnt/app_config/beets/backups"

# create backup directory and set working directory
function prep {
	mkdir -p "$BACKUP_DIR" && cd "$BEETS_WORKING_DIR"
}

# backup the database
function backup_db {
	now=$1
	db="${BEETS_WORKING_DIR}/library.db"

	echo "> backing up database: ${db}"

	sqlite3 "${db}" "VACUUM INTO '${BACKUP_DIR}/library-${now}.db'"
}

# keep 3 most recent .db files, move to NAS, then tidy tmp dir
function tidy {
	rsync -qauzog --no-perms --no-owner --no-group "$BACKUP_DIR/" "$FINAL_DIR"

	count=$(ls -1 "$FINAL_DIR"/*.db 2>/dev/null | wc -l)
	if [ $count != 0 ]; then
		ls -t "$FINAL_DIR"/*.db | tail -n +4 | xargs rm -f
		rm "$BACKUP_DIR"/*.db
	fi
}

# do the actual job
(
	now=$(date '+%Y-%m-%d_%H%M')

	echo "> backing up beets at: ${BEETS_WORKING_DIR}, timestamp: ${now}"

	prep && backup_db $now && tidy
)
