#!/bin/bash

# Kiro CLI Setup Script
# This script installs the Kiro CLI globally and adds it to PATH

set -e

echo "🚀 Setting up Kiro CLI..."

# Navigate to kiro_cli directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_CLI_DIR="$(cd "$SCRIPT_DIR/../kiro_cli" && pwd)"

cd "$KIRO_CLI_DIR"

# Install dependencies
echo "📦 Installing dependencies..."
dart pub get

# Install globally
echo "🌐 Installing CLI globally..."
dart pub global activate --source path .

# Add to PATH if not already present
if ! grep -q 'export PATH.*\.pub-cache/bin' ~/.bashrc 2>/dev/null; then
    echo "📝 Adding to PATH..."
    echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
    echo "✅ Added to ~/.bashrc"
else
    echo "✅ PATH already configured in ~/.bashrc"
fi

# Add to current session
export PATH="$PATH:$HOME/.pub-cache/bin"

echo ""
echo "✅ Kiro CLI installed successfully!"
echo ""
echo "To use the CLI in this terminal session, run:"
echo "  export PATH=\"\$PATH:\$HOME/.pub-cache/bin\""
echo ""
echo "Or restart your terminal to use 'kiro' command directly."
echo ""
echo "Test it with:"
echo "  kiro --version"

