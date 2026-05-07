# Auto-Commit Daemon

This setup automatically commits changes to both the Obsidian vault and Hugo blog repositories, and syncs the posts submodule.

## Files

- `scripts/git-auto-commit.sh` - Main script that watches for file changes
- `systemd/git-auto-commit.service` - Systemd service unit

## Installation

```bash
# Copy the systemd service file
sudo cp systemd/git-auto-commit.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable git-auto-commit.service
sudo systemctl start git-auto-commit.service

# Check status
sudo systemctl status git-auto-commit.service
```

## How It Works

1. **Obsidian Vault Watcher** - Monitors the Syncthing-mounted Obsidian vault directory for changes, auto-commits and pushes to the obsidian-blog repo
2. **Blog Repo Watcher** - Monitors the Hugo blog directory for changes, auto-commits and pushes
3. **Submodule Sync** - When the obsidian-blog repo is updated, pulls the changes and commits them to the Hugo blog repo

## Logs

Logs are written to `/var/log/git-auto-commit.log`

```bash
sudo tail -f /var/log/git-auto-commit.log
```

## Uninstallation

```bash
sudo systemctl stop git-auto-commit.service
sudo systemctl disable git-auto-commit.service
sudo rm /etc/systemd/system/git-auto-commit.service
sudo systemctl daemon-reload
```