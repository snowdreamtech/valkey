#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [valkey] Starting valkey..."; fi

# start valkey
/usr/bin/valkey-server /etc/valkey/valkey.conf --daemonize yes

if [ "$DEBUG" = "true" ]; then echo "→ [valkey] Valkey started."; fi
