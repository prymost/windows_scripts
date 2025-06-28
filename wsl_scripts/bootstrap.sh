#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "🚀 Starting WSL Ubuntu bootstrap process..."
echo "📁 Script directory: $SCRIPT_DIR"

# Run compatibility check first
echo "🔍 Running compatibility check..."
"${SCRIPT_DIR}/check_compatibility.sh"

echo ""
read -p "Continue with bootstrap? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Bootstrap cancelled by user"
    exit 1
fi

echo "🔧 Running initial setup..."
"${SCRIPT_DIR}/setup/initial.sh"

echo "⚙️  Configuring Linux settings..."
"${SCRIPT_DIR}/setup/configure_linux.sh"

echo "📦 Installing applications and packages..."
"${SCRIPT_DIR}/setup/my_installs.sh"

echo "🔄 Updating package database..."
sudo apt update && sudo apt upgrade -y

echo "✅ Bootstrap process completed!"
echo "🔄 Please restart your WSL session to ensure all changes take effect."
echo "💡 Run 'wsl --shutdown' in Windows PowerShell, then restart your WSL terminal"

# Uncomment the line below if you want to restore from backup
# "${SCRIPT_DIR}/setup/restore.sh"
