#!/usr/bin/env bash
set -euo pipefail

# verify_backup.sh
# Verifica checksums SHA256 para um arquivo .tar.gz usando um .sha256 correspondente

FILE=${1:?Usage: verify_backup.sh /path/to/file.tar.gz}
SHAFILE="${FILE}.sha256"

if [ -f "$SHAFILE" ]; then
  echo "Found checksum file: $SHAFILE"
  shasum -a 256 -c "$SHAFILE"
  exit $?
else
  echo "No checksum file found at $SHAFILE; computing local checksum:" 
  shasum -a 256 "$FILE"
  exit 0
fi
