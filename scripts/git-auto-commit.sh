#!/bin/bash

OBSIDIAN_DIR="/mnt/lxc_shares/Sync/Alvin/syncthing/Obsidian/Personal/1. Projects/Blog"
BLOG_DIR="/root/dockeryml/blog"
LOG_FILE="/var/log/git-auto-commit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

watch_git() {
    local dir="$1"
    local name="$2"
    
    cd "$dir" || return 1
    
    while true; do
        inotifywait -r -e modify,create,delete,move "$dir" --exclude '(\.git|\.obsidian)' 2>/dev/null >> "$LOG_FILE"
        
        sleep 2
        
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            cd "$dir"
            git add -A
            git commit -m "Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
            log "$name: Auto-committed changes"
            git push 2>/dev/null || log "$name: Push failed (no remote or network issue)"
        fi
    done
}

log "Starting git-auto-commit daemon"

watch_git "$OBSIDIAN_DIR" "Obsidian" &
watch_git "$BLOG_DIR" "Blog" &

wait