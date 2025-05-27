#!/bin/bash

# ====== CONFIGURABLE SECTION ======
# List of directories whose contents may be deleted
DIRS_TO_CLEAN=(
    "$HOME/Downloads"
)

# List of Git repositories to auto-commit and push
GIT_REPOS=(
    "$HOME/dotfiles"
)
# ==================================

echo "==== Directory Cleanup ===="

for DIR in "${DIRS_TO_CLEAN[@]}"; do
    if [ -d "$DIR" ]; then
        
        ls -al $DIR
        echo "Do you want to delete contents of: $DIR ? (y/n)"
        read -r ANSWER
        if [[ "$ANSWER" == "y" ]]; then
            echo "Deleting contents of $DIR..."
            rm -rf "${DIR:?}/"*
            echo "✅ Cleared: $DIR"
        else
            echo "❌ Skipped: $DIR"
        fi
    else
        echo "⚠️ Directory not found: $DIR"
    fi
done

echo ""
echo "==== Git Auto-Commit & Push ===="

for REPO in "${GIT_REPOS[@]}"; do
    if [ -d "$REPO/.git" ]; then
        echo "Processing Git repo: $REPO"
        cd "$REPO" || continue
        git add .
        git commit -m "Auto commit" && echo "✅ Commit created"
        git push && echo "✅ Pushed to remote"
        echo ""
    else
        echo "⚠️ Not a Git repository: $REPO"
    fi
done

echo "✅ Done."

