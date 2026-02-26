#!/usr/bin/env bash
set -euo pipefail

WORKROOT="$HOME/Documents/Work"
# WORKROOT="$HOME/Library/CloudStorage/OneDrive-UABBiuroBaltic/Projects"
# WORKROOT="$HOME/Library/CloudStorage/ProtonDrive-dovydas.gulbinas@protonmail.com-folder/Work"

usage() {
    cat <<EOF
Usage: $(basename "$0") [command]

Commands:
  init         Create a new project (with Work/ and .ssh subdirs)
  link         Fuzzy–pick a project and link (stow) it [default]
  unlink       Fuzzy–pick a project and unlink (stow -D) it
EOF
}

init_project() {
    read -rp "Enter project name: " PROJECT
    PROJECT="${PROJECT// /_}"   # replace spaces with underscores

    PROJECT_DIR="$WORKROOT/$PROJECT"

    if [[ -d "$PROJECT_DIR" ]]; then
        echo "⚠️ Project '$PROJECT' already exists at $PROJECT_DIR"
        exit 1
    fi

    mkdir -p "$PROJECT_DIR/Work/Documents" "$PROJECT_DIR/.ssh" "$PROJECT_DIR/bin"
    touch "$PROJECT_DIR/.zsh_work"
    touch "$PROJECT_DIR/.env-secrets"
    chmod 600 "$PROJECT_DIR/.env-secrets"

    echo "✅ Created project structure:"
    tree -a "$PROJECT_DIR"
}

pick_project() {
    pushd "$WORKROOT" >/dev/null
    PROJECT=$(ls -d */ | sed 's:/$::' | fzf --prompt="Pick a project: " --height=40%)
    popd >/dev/null
    echo "$PROJECT"
}

link_project() {
    PROJECT=$(pick_project)
    if [[ -n "$PROJECT" ]]; then
        echo "🔗 Linking project: $PROJECT"
        pushd "$WORKROOT" >/dev/null
        stow --verbose --target="$HOME" "$PROJECT"
        popd >/dev/null
    else
        echo "❌ No project selected."
        exit 1
    fi
}

unlink_project() {
    PROJECT=$(pick_project)
    if [[ -n "$PROJECT" ]]; then
        echo "❌ Unlinking project: $PROJECT"
        pushd "$WORKROOT" >/dev/null
        stow -D --verbose --target="$HOME" "$PROJECT"
        popd >/dev/null
    else
        echo "❌ No project selected."
        exit 1
    fi
}

# ---- Main dispatcher ----
cmd="${1:-}"
case "$cmd" in
    init)
        init_project
        ;;
    link|"")
        link_project
        ;;
    unlink)
        unlink_project
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo "Unknown command: $cmd"
        usage
        exit 1
        ;;
esac
