# Auto-Commit Daemon

This setup automatically commits changes to both the Obsidian vault and Hugo blog repositories, and syncs the posts submodule.

## Scripts

- `scripts/git-auto-commit.sh` - Main orchestrator script
- `scripts/watch-obsidian.sh` - Watches and auto-commits Obsidian vault changes
- `scripts/watch-blog.sh` - Watches and auto-commits Hugo blog changes
- `scripts/sync-submodule.sh` - Syncs the posts submodule every 60 seconds

## Systemd Service Files

- `systemd/git-auto-commit.service` - Main orchestrator service
- `systemd/git-watch-obsidian.service` - Obsidian watcher (standalone)
- `systemd/git-watch-blog.service` - Blog watcher (standalone)
- `systemd/git-sync-submodule.service` - Submodule sync (standalone)

## Installation

```bash
# Copy all systemd service files
sudo cp systemd/*.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start the main service
sudo systemctl enable git-auto-commit.service
sudo systemctl start git-auto-commit.service

# Or run individual services
sudo systemctl enable git-watch-obsidian.service
sudo systemctl enable git-watch-blog.service
sudo systemctl enable git-sync-submodule.service
```

## How It Works

1. **watch-obsidian.sh** - Monitors Syncthing-mounted Obsidian vault for changes, auto-commits and pushes to obsidian-blog repo
2. **watch-blog.sh** - Monitors Hugo blog directory for changes, auto-commits and pushes
3. **sync-submodule.sh** - Polls every 60 seconds to pull submodule updates from obsidian-blog, commits to Hugo repo

## Logs

Logs are written to `/var/log/git-auto-commit.log`

```bash
sudo tail -f /var/log/git-auto-commit.log
```

## Uninstallation

```bash
sudo systemctl stop git-auto-commit.service
sudo systemctl disable git-auto-commit.service
sudo rm /etc/systemd/system/git-*.service
sudo systemctl daemon-reload
```