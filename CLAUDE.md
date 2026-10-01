# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles/system config for macOS (nix-darwin) and NixOS, built on a Nix flake, plus a GNU Stow tree for non-Nix dotfiles. Originally derived from `dustinlyons/nixos-config`. Targets: `aarch64-darwin`, `x86_64-darwin`, `x86_64-linux`, `aarch64-linux`.

## Commands

**Build/switch macOS:**
```
nix run .#build-switch
```
(wraps `apps/<system>/build-switch`, which does `nix build .#darwinConfigurations.<system>.system` then `./result/sw/bin/darwin-rebuild switch --flake .#<system>`)

**Rollback macOS:** `nix run .#rollback`

**NixOS rebuild** (hostname must match a file in `configuration/`):
```
sudo THIS_HOSTNAME=<hostname> nixos-rebuild switch -I nixos-config=configuration.nix
```
or `nix run .#build-switch` on Linux. The interactive wrapper `./rebuild.sh` opens `configuration/$HOSTNAME.nix` in nvim, runs `alejandra .`, rebuilds, and auto-commits with the new generation name as the message.

**Format Nix files:** `alejandra .` (required before rebuild; pre-commit also enforces it)

**Lint everything:** `pre-commit run --all-files` (hooks: trailing-whitespace, end-of-file-fixer, check-yaml, shellcheck, yamlfmt, yamllint, bashate for shell scripts, alejandra for `*.nix`)

**Apply stowed dotfiles:** `./stow-link.sh` — only stows a curated subset of packages under `stow/` (see the script for the current enabled list; several packages like `alacritty`, `git`, `ssh` are intentionally commented out because they're managed another way or per-machine).

**Link a work project's dotfiles:** `stow/scripts/bin/projectctl.sh {init|link|unlink}` — fuzzy-picks a directory under `~/Documents/Work` and stows it into `$HOME`.

**Search for a nix package:** `nix search nixpkgs <name>`

## Architecture

**Flake outputs** (`flake.nix`): `darwinConfigurations` (per darwin system) and `nixosConfigurations` (per linux system) are generated via `forAllSystems`/`genAttrs`, plus flake `apps` that expose the scripts in `apps/<system>/` as `nix run .#<name>`. Darwin configs pull in `nix-homebrew` (declarative Homebrew, `mutableTaps = false`) and `home-manager`. Linux configs pull in `disko` and `home-manager`. A private `secrets` flake input (`nix-secrets`, fetched over SSH) backs `agenix`-encrypted values — this input won't resolve without access to that private repo.

**Host entry points:**
- `hosts/darwin/default.nix` — imports `modules/darwin/{secrets,home-manager}.nix` and `modules/shared`, sets macOS `system.defaults`, nix settings (gc, substituters), and Homebrew taps.
- `hosts/nixos/default.nix` — reads hostname from the `$THIS_HOSTNAME` env var at eval time, imports `/etc/nixos/hardware-configuration.nix` (not tracked in this repo — machine-specific), `configuration/${hostname}.nix`, and the root `home.nix`.

**`configuration/*.nix`** — one file per NixOS host (e.g. `herpc.nix`, `herver-nix.nix`), selected by hostname at rebuild time. This is where per-machine NixOS system config (window manager, services, hardware) lives; see `configuration/herver-nix.nix` for the bspwm/picom/syncthing desktop example.

**`modules/{darwin,nixos,shared}/`** — each has the same shape: `default.nix` (module/system-level config), `packages.nix` (package list), `home-manager.nix` (user-level `programs.*`), `files.nix` (static file placement). `modules/shared` is imported by *both* platforms and is where most actual program config (git, zsh, vim, tmux) lives — prefer adding cross-platform config there over duplicating it in `darwin`/`nixos`.

**`home.nix`** (repo root) — the home-manager profile actually applied to the `hermes` user on NixOS (imported by `hosts/nixos/default.nix`); defines zsh (oh-my-zsh, aliases, sourcing of `~/.zsh_aliases`/`~/.zsh_functions`/`~/.zsh_work`/`~/.env`), neovim, ghostty/firefox integration.

**`stow/`** — dotfiles not expressed in Nix, one directory per "package" (`bash/`, `zsh/`, `nvim/`, `ghostty/`, `git/`, `keepassxc/`, `logseq/`, `opencode/`, `scripts/`, etc.), mirroring the target `$HOME` layout. `stow-link.sh` stows a hand-picked subset with `--target=$HOME`; `.stow-local-ignore` / `stow/stow/.stow-global-ignore` exclude `.DS_Store`. `stow/scripts/bin/` holds personal CLI scripts, several of which are symlinks back into other stowed packages (e.g. `rebuild.sh -> ../../../rebuild.sh`).

**`apps/<system>/`** — plain shell scripts (`build`, `build-switch`, `apply`, `rollback`, `copy-keys`, `create-keys`, `check-keys`, plus `install*` on Linux) wired into the flake as `nix run .#<name>`; darwin and linux have slightly different sets (e.g. no `rollback`/`build` app on Linux).

**`nix-bootstrap.sh`** — a first-run templating script (from the upstream `dustinlyons/nixos-config` project this was forked from) that substitutes `%USER%`, `%EMAIL%`, `%GITHUB_USER%`, `%GITHUB_SECRETS_REPO%`, etc. placeholders across the tree and wires in the `secrets` flake input. Not meant to be re-run on an already-bootstrapped checkout.

**`overlays/`** — nixpkgs overlays (e.g. `10-feather-font.nix`), applied via `modules/shared/default.nix`.

## Notes

- Secrets are agenix-encrypted and live in a separate private repo (`nix-secrets`) referenced as a flake input; don't expect them to be present or decryptable without that repo.
- `result` (flake build output) and `*.log` files (`nixos-switch.log`, `nvim.log`) at the repo root are build artifacts, not source.
- Shell scripts are linted with `shellcheck` + `bashate`; keep new scripts passing both.
