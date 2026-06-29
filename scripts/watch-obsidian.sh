#!/bin/bash

OBSIDIAN_DIR="/mnt/lxc_shares/Sync/Alvin/syncthing/Obsidian/Personal/1. Projects/Blog"
LOG_FILE="/var/log/git-auto-commit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

cd "$OBSIDIAN_DIR" || exit 1

log "Obsidian watcher started"

while true; do
    inotifywait -r -e modify,create,delete,move "$OBSIDIAN_DIR" --exclude '(\.git|\.obsidian|\.syncthing)' 2>/dev/null >> "$LOG_FILE"
    
    sleep 2
    
    cd "$OBSIDIAN_DIR"
    git add -A
    if git commit -m "Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null; then
        log "Obsidian: Auto-committed changes"
        git push 2>/dev/null || log "Obsidian: Push failed"
    fi
done