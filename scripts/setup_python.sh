#!/bin/bash

# Python Development Setup for Neovim (macOS/Homebrew)
# Run this script to install the necessary Python tools for your Neovim configuration

echo "🐍 Setting up Python development tools for Neovim..."

# Install pipx if not present
if ! command -v pipx >/dev/null 2>&1; then
    echo "📦 Installing pipx..."
    brew install pipx
    pipx ensurepath
fi

# Install Python formatters and linters using pipx
echo "📦 Installing Python formatters and linters..."

# Install tools using pipx (recommended for macOS)
echo "Installing Python development tools with pipx..."
pipx install black
pipx install isort  
pipx install flake8
pipx install mypy
pipx install pytest
pipx install debugpy

# Ensure PATH is updated
pipx ensurepath

# Install Pyright language server
if ! command -v pyright-langserver >/dev/null 2>&1; then
    echo "🔧 Installing Pyright language server..."
    if command -v pnpm >/dev/null 2>&1; then
        pnpm install -g pyright
    elif command -v npm >/dev/null 2>&1; then
        npm install -g pyright
    else
        echo "⚠️  Please install Node.js and pnpm/npm first"
    fi
fi

# Install fd-find if not present (for venv selector)
if ! command -v fd >/dev/null 2>&1; then
    echo "📁 Installing fd-find..."
    brew install fd
fi

echo ""
echo "✅ Python development setup complete!"
echo ""
echo "🔧 Next steps:"
echo "1. Restart your terminal (or run: source ~/.zshrc)"
echo "2. Restart Neovim"
echo "3. Run :Lazy sync to install new plugins"
echo "4. Open a Python file and use <leader>vs to select a virtual environment"
echo "5. Use <leader>f to format Python code"
echo "6. Use <leader>tn to run nearest test"
echo ""
echo "📝 Key bindings for Python:"
echo "   <leader>vs  - Select virtual environment"
echo "   <leader>vc  - Select cached virtual environment"
echo "   <leader>f   - Format code (black + isort)"
echo "   <leader>tn  - Run nearest test"
echo "   <leader>tf  - Run file tests"
echo "   <leader>ts  - Toggle test summary"
echo "   <leader>db  - Toggle breakpoint"
echo "   <leader>dc  - Continue debugging"
echo "   <leader>nf  - Generate function docstring"
echo "   <leader>nc  - Generate class docstring"
echo "   <leader>rs  - Start Python REPL"
echo "   <leader>pr  - Run Python file"
echo "   <leader>pt  - Run pytest on current file"
echo "   <leader>pT  - Run all pytest"
echo ""
