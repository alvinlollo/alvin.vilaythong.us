# How AGENTS.md was made

This file documents the process used to create `AGENTS.md` for this repository.

## Method

The approach was a read-only investigation guided by the user's prompt (the "How to investigate" and "What to extract" sections).

### 1. Top-level survey

Read the root directory listing to identify the project shape — a Hugo blog with Blowfish theme, scripts, systemd services, and build output dirs.

### 2. Config files

Read the highest-signal sources first:

- **`hugo.toml`** — root config (3 lines, minimal) confirmed the site is a Hugo project
- **`config/_default/`** — all 6 files (hugo.toml, params.toml, markup.toml, menus.en.toml, languages.en.toml, module.toml) read to understand full site configuration
- **`themes/blowfish/config.toml`** — confirmed Hugo extended requirement (`min = "0.158.0"`)
- **`.gitmodules`** — revealed the two submodules: theme (`themes/blowfish`) and content (`content/posts`)

### 3. Scripts and infrastructure

- **`scripts/`** — read all 4 shell scripts to understand the auto-commit daemon:
  - `git-auto-commit.sh` (orchestrator)
  - `watch-obsidian.sh` (watches Obsidian vault at `/mnt/lxc_shares/...`)
  - `watch-blog.sh` (watches Hugo repo directory)
  - `sync-submodule.sh` (polls submodule every 60s)
- **`systemd/`** — read all 4 service files to understand deployment as system services
- **`docs/systemd.md`** — confirmed the documented install/uninstall workflow

### 4. Build artifacts

- **`built-site/CNAME`** — confirmed deployment target (`alvin.vilaythong.us`) and GitHub Pages setup
- Checked `public_new/` and `built-site/` for differences; noted both exist
- Checked `go.mod` — only in the theme, not at repo root (pure Hugo, no Go module)

### 5. Git and CI

- Ran `git branch -a` and `git remote -v` — confirmed `gh-pages` branch and GitHub origin
- Checked `.github/workflows/` — no CI workflows at repo level (only theme has workflows)
- Checked for `Makefile`, `package.json`, `.gitignore` — none exist
- Confirmed Hugo binary at `/usr/local/bin/hugo v0.161.1+extended`

### 6. Existing instruction files

Searched for `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.cursor/rules/`, `opencode.json*`, `.github/copilot-instructions.md` — none found.

## Output

The result is a compact `AGENTS.md` with 7 sections covering build commands, content submodule workflow, config layout, deployment, auto-commit daemon, and tooling notes. Every claim is verified against executable sources (config files, scripts, git state, and installed binaries).
