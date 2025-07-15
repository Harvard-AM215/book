#!/usr/bin/env bash
#
# build.sh
#
# Builds the Jupyter Book located in the `jupyter-book` subdirectory.
# This is a thin wrapper that lets the build tool do the talking.

# Exit immediately if any command fails
set -e

# --- Determine the project's root directory and book directory ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT=$( dirname "$SCRIPT_DIR" )
BOOK_DIR="$PROJECT_ROOT/jupyter-book"

# --- Validate that the book directory actually exists ---
if [ ! -d "$BOOK_DIR" ]; then
    echo "❌ Error: Book directory not found at '$BOOK_DIR'"
    exit 1
fi

# --- Run the build ---
# We let jupyter-book produce all the output.
uv run jupyter-book build "$BOOK_DIR" "$@"
