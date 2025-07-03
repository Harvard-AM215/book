# scripts/dev.sh - Start development server
#!/bin/bash
# Start development environment

set -e

echo "🚀 Starting development environment..."

# Check if we're in a virtual environment
if [ -z "$VIRTUAL_ENV" ] && [ -z "$NIX_STORE" ]; then
    echo "⚠️  No virtual environment detected"
    echo "Please activate your environment first:"
    echo "  - Nix: nix develop"
    echo "  - uv: source .venv/bin/activate"
    echo "  - venv: source .venv/bin/activate"
    exit 1
fi

# Build the book
./scripts/build.sh

# Start Jupyter Lab in the background
echo "Starting Jupyter Lab..."
jupyter lab --no-browser --port=8888 &
JUPYTER_PID=$!

# Start file watcher in the background
echo "Starting file watcher..."
./scripts/watch.sh &
WATCH_PID=$!

# Function to cleanup background processes
cleanup() {
    echo "Cleaning up..."
    kill $JUPYTER_PID $WATCH_PID 2>/dev/null || true
    exit 0
}

trap cleanup INT TERM

echo "✅ Development environment started!"
echo "📝 Jupyter Lab: http://localhost:8888"
echo "📖 Book: file://$(pwd)/_build/html/index.html"
echo "Press Ctrl+C to stop"

# Wait for interrupt
wait

