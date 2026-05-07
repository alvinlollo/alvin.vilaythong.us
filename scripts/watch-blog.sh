#!/bin/bash

BLOG_DIR="/root/dockeryml/blog"
LOG_FILE="/var/log/git-auto-commit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

cd "$BLOG_DIR" || exit 1

log "Blog watcher started"

while true; do
    inotifywait -r -e modify,create,delete,move "$BLOG_DIR" --exclude '(\.git|\.obsidian|public|resources)' 2>/dev/null >> "$LOG_FILE"
    
    sleep 2
    
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        cd "$BLOG_DIR"
        git add -A
        git commit -m "Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
        log "Blog: Auto-committed changes"
        git push 2>/dev/null || log "Blog: Push failed"
    fi
done