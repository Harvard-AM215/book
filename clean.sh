# scripts/clean.sh - Clean build artifacts
#!/bin/bash
# Clean all build artifacts

set -e

echo "🧹 Cleaning build artifacts..."

# Remove build directories
rm -rf _build .jupyter_cache

# Remove Python cache
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true

echo "✅ Clean complete!"

# Make scripts executable
chmod +x scripts/*.sh
