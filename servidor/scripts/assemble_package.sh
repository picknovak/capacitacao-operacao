#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  cat <<'EOF'
Usage: assemble_package.sh [DEST_DIR]

Creates a timestamped package directory on the server containing:
- a copy of the `Projeto` repo found on the machine
- any `relatorio_*.txt`, `coleta_*.tar.gz` and `*.sha256` files
Then creates a compressed tarball and a SHA-256 checksum.

Run as root (or with sudo) to ensure files are copied correctly.
EOF
  exit 0
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run with sudo or as root: sudo ./assemble_package.sh [DEST_DIR]"
  exit 1
fi

timestamp=$(date +%Y%m%d_%H%M)
DEFAULT_PARENT="/srv/data"
if [ -n "${1:-}" ]; then
  dest="$1"
elif [ -d "$DEFAULT_PARENT" ] && [ -w "$DEFAULT_PARENT" ]; then
  dest="$DEFAULT_PARENT/Projeto_pacote_${timestamp}"
else
  dest="/root/Projeto_pacote_${timestamp}"
fi

mkdir -p "$dest/artifacts"
echo "Destination: $dest"

# locate source repo (Capacitacao preferred, Projeto as fallback)
PROJECT_SRC=""
for p in /opt/operacao/capacitacao-operacao /home/*/Capacitacao /home/admin1/Capacitacao /root/Capacitacao /root/Projeto /home/*/Projeto /home/Projeto /srv/Projeto /opt/Projeto /home/admin1/Projeto /home/ubuntu/Projeto; do
  if [ -d "$p" ]; then
    PROJECT_SRC="$p"
    break
  fi
done
if [ -z "$PROJECT_SRC" ]; then
  # fallback to current dir if it looks like a repo
  if [ -d "./docs" ] || [ -f "./README.md" ]; then
    PROJECT_SRC="$(pwd)"
  fi
fi

if [ -n "$PROJECT_SRC" ] && [ -d "$PROJECT_SRC" ]; then
  echo "Copying Projeto from $PROJECT_SRC"
  rsync -a --exclude 'coleta_*.tar.gz' --exclude 'relatorio_*.txt' --exclude '*.tar.gz.sha256' "$PROJECT_SRC/" "$dest/Projeto/"
else
  echo "Could not find Projeto directory automatically. Create $dest/Projeto and place files there as needed." 
  mkdir -p "$dest/Projeto"
fi

echo "Collecting artifacts (relatorio_*, coleta_*, sha256)"
# Search common locations and copy artifacts
for loc in "$PROJECT_SRC" /root /home/* /srv/data /tmp; do
  [ -d "$loc" ] || continue
  find "$loc" -maxdepth 2 -type f \( -name 'relatorio_*.txt' -o -name 'coleta_*.tar.gz' -o -name '*.tar.gz.sha256' -o -name '*.sha256' \) -print0 \
    | xargs -0 -I{} cp -v --parents {} "$dest/artifacts/" 2>/dev/null || true
done

echo "Creating listing(s) for any collected tar.gz files"
find "$dest/artifacts" -type f -name 'coleta_*.tar.gz' -print0 | while IFS= read -r -d '' f; do
  listfile="$f.list.txt"
  tar -tzf "$f" > "$listfile" 2>/dev/null || echo "(could not list $f)" > "$listfile"
done

echo "Creating final tar.gz and checksum"
parentdir=$(dirname "$dest")
basename=$(basename "$dest")
final_tar="${parentdir}/${basename}.tar.gz"
tar -C "$parentdir" -czf "$final_tar" "$basename"
sha256sum "$final_tar" > "${final_tar}.sha256"

echo "Package created: $final_tar"
echo "Checksum saved to: ${final_tar}.sha256"

exit 0
