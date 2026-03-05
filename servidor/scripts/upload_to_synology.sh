#!/usr/bin/env bash
set -euo pipefail

# upload_to_synology.sh
# Rsync local backup files to Synology (SSH) or copy to a mounted path.
# Usage: upload_to_synology.sh <source_path>   (source can be dir or file)

SRC=${1:?Provide source file or directory}
# Configure these variables as needed
DEST_USER=${DEST_USER:-backupuser}
DEST_HOST=${DEST_HOST:-synology.example.local}
DEST_PATH=${DEST_PATH:-/volume1/backups/servidor}
SSH_PORT=${SSH_PORT:-22}
SSH_KEY=${SSH_KEY:-~/.ssh/id_ed25519}

if mount | grep -q "$DEST_HOST:$DEST_PATH"; then
  echo "Detected mount; using cp"
  mkdir -p "$DEST_PATH"
  cp -a "$SRC" "$DEST_PATH/"
  exit 0
fi

echo "Syncing $SRC -> ${DEST_USER}@${DEST_HOST}:${DEST_PATH} (rsync over ssh)"
rsync -avz -e "ssh -i ${SSH_KEY} -p ${SSH_PORT}" --delete --partial "$SRC" "${DEST_USER}@${DEST_HOST}:${DEST_PATH}/"

echo "Upload complete"

exit 0
