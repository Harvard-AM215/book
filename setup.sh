#!/usr/bin/env bash
# setup.sh - Universal setup script

set -e

echo "🚀 Setting up AM215 Course Materials Development Environment"
echo "============================================================"

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

OS=$(detect_os)
echo "Detected OS: $OS"

# Check for Nix first
if command_exists nix && [ -f flake.nix ]; then
    echo "✅ Nix detected with flake.nix"
    echo "Setting up Nix development environment..."
    
    # Enable direnv if available
    if command_exists direnv; then
        echo "✅ direnv detected"
        echo "Run 'direnv allow' to activate the environment"
    else
        echo "⚠️  direnv not found. Install direnv for automatic environment activation"
        echo "Alternatively, run 'nix develop' to enter the dev shell"
    fi
    
    # Create .envrc if it doesn't exist
    if [ ! -f .envrc ]; then
        echo "use flake" > .envrc
        echo "Created .envrc file"
    fi
    
elif command_exists uv && [ -f pyproject.toml ]; then
    echo "✅ uv detected with pyproject.toml"
    echo "Setting up uv environment..."
    
    # Create virtual environment and install dependencies
    uv venv --python 3.11
    uv sync
    
    echo "✅ uv environment created"
    echo "Activate with: source .venv/bin/activate"
    
elif command_exists python3 && [ -f requirements.txt ]; then
    echo "✅ Python detected with requirements.txt"
    echo "Setting up traditional venv environment..."
    
    # Create virtual environment
    python3 -m venv .venv
    source .venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install dependencies
    pip install -r requirements.txt
    
    # Install development dependencies if available
    if [ -f requirements-dev.txt ]; then
        pip install -r requirements-dev.txt
    fi
    
    echo "✅ Virtual environment created"
    echo "Activate with: source .venv/bin/activate"
    
else
    echo "❌ No suitable environment found"
    echo "Please install one of the following:"
    echo "  - Nix (recommended for reproducible environments)"
    echo "  - uv (modern Python package management)"
    echo "  - Python 3.11+ with pip"
    exit 1
fi

# Create necessary directories
mkdir -p content/{week01,week02,week03,week04,week05,week06,week07,week08,week09,week10,week11,week12,week13,week14,week15}
mkdir -p content/{appendices,resources/{figures,data,code}}
mkdir -p scripts

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Activate your environment (see instructions above)"
echo "2. Run './scripts/build.sh' to build the book"
echo "3. Open '_build/html/index.html' in your browser"
echo "4. Start editing content in the 'content/' directory"

