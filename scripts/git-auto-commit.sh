#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="/var/log/git-auto-commit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "Starting git-auto-commit daemon"

"$SCRIPT_DIR/watch-obsidian.sh" &
"$SCRIPT_DIR/watch-blog.sh" &
"$SCRIPT_DIR/sync-submodule.sh" &

wait