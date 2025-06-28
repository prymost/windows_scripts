#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

# Install packages and applications using package lists
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "📦 Installing development tools and applications..."

# APT packages
echo "📋 Installing APT packages..."
sudo apt update

# Development tools
sudo apt install -y \
    jq \
    bat \
    direnv \
    micro \
    kubectl

# Language-specific tools
echo "🔧 Installing language-specific tools..."

# Ruby with rbenv
echo "💎 Installing Ruby with rbenv..."
if ! command -v rbenv &> /dev/null; then
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

    # Install latest Ruby
    LATEST_RUBY=$(rbenv install -l | grep -v - | tail -1 | tr -d ' ')
    rbenv install $LATEST_RUBY
    rbenv global $LATEST_RUBY
else
    echo "✅ rbenv already installed"
fi

# Python tools
echo "🐍 Installing Python development tools..."
pip3 install --user \
    pipenv \
    flake8 \
    pytest

# Oh My Zsh (if Zsh is installed)
if command -v zsh &> /dev/null; then
    echo "🐚 Installing Oh My Zsh..."
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

        # Install plugins
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

        # Update .zshrc with plugins
        sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker python pip)/' ~/.zshrc
    else
        echo "✅ Oh My Zsh already installed"
    fi
fi

# Set up git configuration for common workflows
echo "🔧 Setting up Git configuration..."
# Configure Git to handle line endings properly in WSL
git config --global core.autocrlf input
git config --global core.eol lf

# Create useful scripts
echo "📝 Creating utility scripts..."
mkdir -p ~/bin

# Add ~/bin to PATH if not already there
if ! grep -q '$HOME/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi

echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

# System optimizations for WSL
echo "⚡ Applying WSL optimizations..."

echo "✅ Installation completed!"
echo ""
echo "🎉 Recommended next steps:"
echo "   1. Restart WSL: wsl --shutdown (in Windows PowerShell)"
echo "   2. Change default shell to zsh: chsh -s \$(which zsh)"
echo "   3. Configure Git with your credentials: git config --global user.name 'Your Name'"
echo "   4. Configure Git with your email: git config --global user.email 'your.email@example.com'"
echo "   5. Install VS Code WSL extension for seamless development"
echo "   6. Set up SSH keys: ssh-keygen -t ed25519 -C 'your.email@example.com'"
echo "   7. Configure rbenv Ruby environment if needed"
