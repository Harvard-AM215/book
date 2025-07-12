# scripts/dev.sh - Enhanced for collaborators
#!/usr/bin/env bash
set -e

echo "🚀 Setting up AM215 development environment..."

# Sync all MyST files to notebooks
echo "Creating/updating paired notebooks..."
uv run jupytext --sync content/**/*.md

# Start Jupyter Lab for notebook editing
echo "Starting Jupyter Lab..."
uv run jupyter lab --no-browser &
JUPYTER_PID=$!

# Function to cleanup and sync back to MyST
cleanup() {
    echo "Syncing notebooks back to MyST files..."
    uv run jupytext --sync content/**/*.ipynb
    echo "Stopping Jupyter Lab..."
    kill $JUPYTER_PID 2>/dev/null || true
    exit 0
}

trap cleanup INT TERM

echo "✅ Development environment ready!"
echo "📝 Jupyter Lab: http://localhost:8888"
echo "📖 MyST files are paired with .ipynb files"
echo "💡 Edit either format - they stay in sync!"
echo "Press Ctrl+C to stop and sync changes back"

wait
