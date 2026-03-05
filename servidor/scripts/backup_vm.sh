#!/usr/bin/env bash
set -euo pipefail

# backup_vm.sh
# Minimal helper: lists libvirt VMs and their disk paths; if VM is shut off and
# DEST is provided, copies disk images to DEST. Avoids snapshotting running VMs by default.

DEST=${1:-/var/backups/vm}
mkdir -p "$DEST"

if ! command -v virsh >/dev/null 2>&1; then
  echo "virsh/libvirt not available on this host. Exiting." >&2
  exit 2
fi

echo "Listing VMs and disk paths"
virsh list --all

for vm in $(virsh list --all --name | sed '/^$/d'); do
  echo "\nVM: $vm"
  virsh dominfo "$vm" 2>/dev/null || true
  echo "Disks:"; virsh domblklist "$vm" --details 2>/dev/null || true
  state=$(virsh domstate "$vm" 2>/dev/null || true)
  echo "State: $state"
  if echo "$state" | grep -iq "shut"; then
    echo "VM is off. Copying disk files to $DEST"
    # Get disk file paths
    virsh domblklist "$vm" --details | awk '/file/ {print $4}' | while read -r disk; do
      [ -z "$disk" ] && continue
      echo "Copying $disk -> $DEST"
      cp -av "$disk" "$DEST/" || echo "Failed to copy $disk"
    done
  else
    echo "VM is running; skipping disk copy. Consider using virsh snapshot or shutdown for consistent copy."
  fi
done

echo "VM backup helper finished. Review $DEST for copied images."

exit 0
