#!/usr/bin/env bash
#
# serve.sh
#
# A "live-reloading" server hack for jupyter-book v1.
# It performs an initial build and then watches the `jupyter-book`
# subdirectory for changes, rebuilding as needed.
#
# REQUIRES: `watchdog` (run `uv run pip install watchdog`)

# Exit immediately if any command fails
set -e

# --- Determine paths ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT=$( dirname "$SCRIPT_DIR" )
BOOK_DIR="$PROJECT_ROOT/jupyter-book"

# --- Validate that the book directory actually exists ---
if [ ! -d "$BOOK_DIR" ]; then
    echo "❌ Error: Book directory not found at '$BOOK_DIR'"
    exit 1
fi

# --- Perform an Initial Build ---
# The build.sh script will be run, showing the jupyter-book output.
"$SCRIPT_DIR/build.sh"

# --- Start the File Watcher ---
echo "---"
echo "✅ Initial build complete. Use the link from the output above."
echo "👀 Watching for changes in '$BOOK_DIR'... (Press Ctrl+C to stop)"
echo "---"

# The command to run when a file changes.
REBUILD_COMMAND="$SCRIPT_DIR/build.sh"

# Use `watchmedo` to monitor the book's subdirectory.
uv run watchmedo shell-command \
    --command="$REBUILD_COMMAND" \
    --patterns="*.md;*.ipynb;*.yml;*.css;*.js" \
    --recursive \
    --ignore-directories \
    --ignore-patterns="*/_build/*" \
    "$BOOK_DIR"

echo "---"
echo "✅ Watcher stopped."
echo "---"
