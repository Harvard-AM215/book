# scripts/build.sh - Universal build script
#!/usr/bin/env bash
# Build script that works in any environment

set -e

echo "🔨 Building AM215 Course Materials..."

# Clean previous build
if [ -d "_build" ]; then
    echo "Cleaning previous build..."
    rm -rf _build
fi

# Build the book
echo "Building Jupyter Book..."
jupyter-book build . --all

echo "✅ Build complete!"
echo "📖 Open _build/html/index.html in your browser"

# scripts/watch.sh - Auto-rebuild script
#!/usr/bin/env bash
# Watch for changes and auto-rebuild

set -e

echo "👀 Watching for changes..."
echo "Press Ctrl+C to stop"

# Check if watchdog is available
if ! command -v watchmedo &> /dev/null; then
    echo "⚠️  watchdog not found. Installing..."
    pip install watchdog
fi

# Watch for changes
watchmedo shell-command \
    --patterns="*.md;*.py;*.ipynb;*.yml;*.yaml;*.bib" \
    --recursive \
    --command='echo "Change detected, rebuilding..." && jupyter-book build . --all && echo "✅ Rebuild complete!"' \
    --wait \
    content/
