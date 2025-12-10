#!/bin/bash

set -e
REPO_USER="FrancescoPoluzzi"
REPO_NAME="git-safe-check"
BRANCH="main"

INSTALL_DIR="$HOME/.git-safe-check/bin"
TARGET_FILE="$INSTALL_DIR/git"
SOURCE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH/src/git-safe-check.sh"

echo -e "\n🛡️  Installing Git Safety Check..."

if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    echo "📁 Created directory: $INSTALL_DIR"
fi

echo "⬇️  Downloading script..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$SOURCE_URL" -o "$TARGET_FILE"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TARGET_FILE" "$SOURCE_URL"
else
    echo "❌ Error: Neither curl nor wget found. Cannot download."
    exit 1
fi

chmod +x "$TARGET_FILE"
echo "🔑 Permissions set."

SHELL_CONFIG=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    SHELL_CONFIG="$HOME/.bashrc" 
    echo "⚠️  Could not detect shell. Defaulting to $SHELL_CONFIG"
fi

PATH_EXPORT="export PATH=\"$INSTALL_DIR:\$PATH\""
MARKER="# Git Safe Check Tool"

if grep -q "$MARKER" "$SHELL_CONFIG"; then
    echo "ℹ️  Path already configured in $SHELL_CONFIG"
else
    echo "" >> "$SHELL_CONFIG"
    echo "$MARKER" >> "$SHELL_CONFIG"
    echo "$PATH_EXPORT" >> "$SHELL_CONFIG"
    echo "✅ Added to $SHELL_CONFIG"
fi

echo -e "\n🎉 Installation complete!"
echo -e "👉 \033[1mPlease restart your terminal\033[0m or run: source $SHELL_CONFIG"
echo -e "   Then try running: git push\n"
