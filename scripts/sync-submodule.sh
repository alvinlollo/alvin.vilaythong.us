#!/bin/bash

BLOG_DIR="/root/dockeryml/blog"
LOG_FILE="/var/log/git-auto-commit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

cd "$BLOG_DIR" || exit 1

log "Submodule sync started"

while true; do
    sleep 60
    
    git fetch origin 2>/dev/null
    git submodule update --remote --init 2>/dev/null
    cd "$BLOG_DIR"
    git add content/posts
    if git commit -m "Update posts submodule: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null; then
        log "Submodule: Updated and committed"
        git push 2>/dev/null || log "Submodule: Push failed"
    fi
done