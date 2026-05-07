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
    if git submodule update --remote --init 2>/dev/null; then
        cd "$BLOG_DIR"
        if [[ -n $(git status --porcelain content/posts 2>/dev/null) ]]; then
            git add content/posts
            git commit -m "Update posts submodule: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
            log "Submodule: Updated and committed"
            git push 2>/dev/null || log "Submodule: Push failed"
        fi
    fi
done