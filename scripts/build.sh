#!/usr/bin/env bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT=$( dirname "$SCRIPT_DIR" )
BOOK_DIR="$PROJECT_ROOT/jupyter-book"
if [ ! -d "$BOOK_DIR" ]; then
    echo "❌ Error: Book source directory not found at '$BOOK_DIR'"
    exit 1
fi
uv run jupyter-book build "$BOOK_DIR" "$@"
