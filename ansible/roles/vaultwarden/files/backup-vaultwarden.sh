#!/bin/bash

# backup_vaultwarden.sh
#
# Backups up `db.sqlite3` and `attachments` from vaultwarden.

VAULTWARDEN_WORKING_DIR="/var/lib/vaultwarden"
BACKUP_DIR="/tmp/vaultwarden-backups"
FINAL_DIR="/Vaultwarden-data/backups"

# create backup directory and set working directory
function prep {
	mkdir -p "$BACKUP_DIR" && cd "$VAULTWARDEN_WORKING_DIR"
}

# backup the database
function backup_db {
	now=$1
	db="${VAULTWARDEN_WORKING_DIR}/data/db.sqlite3"

	echo "> backing up database: ${db}"

	sqlite3 "${db}" "VACUUM INTO '${BACKUP_DIR}/db-${now}.sqlite3'"
}

# backup the attachments
function backup_attachments {
	now=$1
	dir="${VAULTWARDEN_WORKING_DIR}/data/attachments"

	if [ -d "${dir}" ]; then
		echo "> backing up attachments dir: ${dir}"

		cp -R "$dir" "${BACKUP_DIR}/attachments-${now}"
	fi
}

# keep 3 most recent .sqlite3 files and attachment dirs, move to NAS, then tidy tmp dir
function tidy {
	rsync -qauzog "$BACKUP_DIR/" "$FINAL_DIR"

	count=$(ls -1 "$FINAL_DIR"/*.sqlite3 2>/dev/null | wc -l)
	if [ $count != 0 ]; then
		ls -t "$FINAL_DIR"/*.sqlite3 | tail -n +4 | xargs rm -f
		rm "$BACKUP_DIR"/*.sqlite3
	fi

	count=$(find "$FINAL_DIR"/attachments-* -maxdepth 0 -type d 2>/dev/null | wc -l)
	if [ $count != 0 ]; then
		ls -Fd "$FINAL_DIR"/attachments-* | grep '/$' | head -n -3 | while read -r d; do rm -rf "$d"; done
		rm -r "$BACKUP_DIR"/attachments-*
	fi
}

# do the actual job
(
	now=$(date '+%Y-%m-%d_%H%M')

	echo "> backing up vaultwarden at: ${VAULTWARDEN_WORKING_DIR}, timestamp: ${now}"

	prep && backup_db $now && backup_attachments $now && tidy
)
