# AGENTS.md

## Build & preview
- `hugo server` — dev server with live reload (Hugo extended required, v0.158.0+)
- `hugo --destination built-site` — production build
- `hugo --destination public_new` — experimental/secondary build

## Content workflow
- `content/posts/` is a **git submodule** pointing to `git@github.com:alvinlollo/obsidian-blog.git`
- To pull latest posts: `git submodule update --remote --init content/posts`
- Edit post content inside `content/posts/` (the submodule's work tree); commit/push there separately
- The root repo tracks the submodule pointer; after updating the submodule, commit the pointer change in the root

## Config
- Root `hugo.toml` is minimal (3 lines)
- Full site config lives in `config/_default/` (params, markup, menus, languages, module)
- Theme: Blowfish v2.103.0 at `themes/blowfish/`

## Deployment
- GitHub Pages via `gh-pages` branch
- `built-site/` is the deployment target directory (contains `CNAME` for `alvin.vilaythong.us`)
- No CI/CD workflows configured at repo level

## Auto-commit daemon
- Systemd services in `systemd/` auto-watch for changes and push
- Scripts in `scripts/`: `git-auto-commit.sh` (orchestrator), `watch-obsidian.sh` (Obsidian vault), `watch-blog.sh` (Hugo repo), `sync-submodule.sh` (polls submodule every 60s)
- Logs: `/var/log/git-auto-commit.log`
- See `docs/systemd.md` for install/uninstall instructions

## Tooling notes
- No `package.json`, `Makefile`, or `.gitignore`
- Hugo extended binary at `/usr/local/bin/hugo` (v0.161.1)
