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

pull_submodule() {
    while true; do
        sleep 60
        
        cd "$BLOG_DIR" || continue
        git fetch origin 2>/dev/null
        if git submodule update --remote --init 2>/dev/null; then
            cd "$BLOG_DIR"
            if [[ -n $(git status --porcelain content/posts 2>/dev/null) ]]; then
                git add content/posts
                git commit -m "Update posts submodule: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
                log "Blog: Submodule updated and committed"
                git push 2>/dev/null || log "Blog: Push failed (no remote or network issue)"
            fi
        fi
    done
}

log "Starting git-auto-commit daemon"

watch_git "$OBSIDIAN_DIR" "Obsidian" &
watch_git "$BLOG_DIR" "Blog" &
pull_submodule &

wait