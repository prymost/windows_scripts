#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "🔄 ***** System Package Update *****"
echo "Updating package lists..."
sudo apt update

echo "Upgrading all packages..."
sudo apt upgrade -y

echo "🍺 ***** Homebrew Update *****"
if command -v brew &> /dev/null; then
    echo "Updating Homebrew itself..."
    brew update

    echo "Upgrading Homebrew packages..."
    brew upgrade

    echo "Cleaning up Homebrew..."
    brew cleanup
else
    echo "Homebrew not found, skipping brew updates"
fi

echo "💎 ***** Ruby Gems Update *****"
if command -v rbenv &> /dev/null; then
    # Check if there's a global Ruby version set
    if rbenv global 2>/dev/null | grep -v "system" &> /dev/null; then
        RUBY_VERSION=$(rbenv global)
        echo "Updating gems for Ruby $RUBY_VERSION..."
        gem update --system
        gem update
    else
        echo "No global Ruby version set via rbenv, skipping gem updates"
    fi
elif command -v ruby &> /dev/null; then
    echo "Using system Ruby, updating gems..."
    gem update --system
    gem update
else
    echo "Ruby not found, skipping gem updates"
fi

echo "🐍 ***** Python Packages Update *****"
if command -v python3 &> /dev/null; then
    echo "Updating pip..."
    python3 -m pip install --user --upgrade pip

    # Update user-installed packages
    if python3 -m pip list --user 2>/dev/null | grep -q .; then
        echo "Updating user-installed Python packages..."
        python3 -m pip list --user --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 python3 -m pip install --user -U 2>/dev/null || echo "Some packages may have failed to update"
    else
        echo "No user-installed Python packages found"
    fi

    # Update pipenv if installed
    if command -v pipenv &> /dev/null; then
        echo "Updating pipenv..."
        python3 -m pip install --user --upgrade pipenv
    fi

    # Update poetry if installed
    if command -v poetry &> /dev/null; then
        echo "Updating poetry..."
        poetry self update 2>/dev/null || python3 -m pip install --user --upgrade poetry
    fi
else
    echo "Python3 not found, skipping pip updates"
fi

echo "📦 ***** NPM Packages Update *****"
if command -v npm &> /dev/null; then
    echo "Updating npm itself..."
    npm install -g npm@latest

    # Check if there are global packages installed
    if npm list -g --depth=0 2>/dev/null | grep -q .; then
        echo "Updating global npm packages..."
        npm update -g
    else
        echo "No global npm packages found"
    fi
else
    echo "npm not found, skipping npm updates"
fi

echo "🐳 ***** Docker Update *****"
if command -v docker &> /dev/null; then
    echo "Pulling latest Docker images..."
    # Update commonly used base images
    docker pull ubuntu:latest 2>/dev/null || echo "Failed to pull ubuntu:latest"
    docker pull node:latest 2>/dev/null || echo "Failed to pull node:latest"
    docker pull python:latest 2>/dev/null || echo "Failed to pull python:latest"

    echo "Cleaning up Docker..."
    docker system prune -f
else
    echo "Docker not found, skipping Docker updates"
fi

echo "⭐ ***** Starship Update *****"
if command -v starship &> /dev/null; then
    echo "Updating Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship not found, skipping Starship update"
fi

echo "☁️  ***** AWS CLI Update *****"
if command -v aws &> /dev/null; then
    echo "Current AWS CLI version:"
    aws --version
    echo "💡 To update AWS CLI v2, re-run the installation from my_installs.sh"
else
    echo "AWS CLI not found, skipping AWS CLI update"
fi

echo "🐙 ***** GitHub CLI Update *****"
if command -v gh &> /dev/null; then
    echo "Current GitHub CLI version:"
    gh version
    echo "Updating GitHub CLI..."
    sudo apt update
    sudo apt install --only-upgrade gh -y
else
    echo "GitHub CLI not found, skipping gh update"
fi

echo "🔧 ***** Development Tools Update *****"
# Update Neovim if installed via AppImage
if [[ -f "/usr/local/bin/nvim" ]]; then
    echo "Updating Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
fi

echo "🧹 ***** Cleanup *****"
sudo apt autoremove -y
sudo apt autoclean

# Clean up old kernels (WSL specific)
echo "Cleaning up old packages..."
sudo apt autoremove --purge -y

# Update locate database
if command -v updatedb &> /dev/null; then
    echo "Updating locate database..."
    sudo updatedb
fi

echo "✅ All updates completed!"
echo ""
echo "📊 System summary:"
echo "=================="
echo "🐧 OS: $(lsb_release -d | cut -f2)"
echo "🔧 Kernel: $(uname -r)"
echo "💾 Disk usage: $(df -h / | awk 'NR==2{print $5}') used"
echo "🧠 Memory: $(free -h | awk 'NR==2{print $3 "/" $2}') used"

if command -v neofetch &> /dev/null; then
    echo ""
    echo "📱 System info:"
    neofetch --off
fi
