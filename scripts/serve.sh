#!/usr/bin/env bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT=$( dirname "$SCRIPT_DIR" )
BOOK_DIR="$PROJECT_ROOT/jupyter-book"
BUILD_DIR="$BOOK_DIR/_build/html"
cleanup() {
  echo; echo "---"; echo "🛑 Stopping TeachBooks server...";
  uv run teachbooks serve stop > /dev/null 2>&1
  echo "✅ Server stopped."; echo "---";
}
trap cleanup EXIT
"$SCRIPT_DIR/build.sh"
echo "---"; echo "✅ Starting TeachBooks server...";
SERVER_LOG=$(mktemp)
uv run teachbooks serve path "$BUILD_DIR" > "$SERVER_LOG" 2>&1 &
while ! grep -q "server running on:" "$SERVER_LOG"; do sleep 0.1; done
BASE_URL=$(grep "server running on:" "$SERVER_LOG" | awk '{print $5}')
FULL_URL="${BASE_URL}/index.html"
echo; echo "✅ Server is running. Your book is available at:";
echo "🔗 ${FULL_URL}"; echo
while true; do
  echo "---"
  read -n 1 -s -r -p "👀 Press any key to rebuild the book, or Ctrl+C to exit..."
  echo
  "$SCRIPT_DIR/build.sh"
  echo
  echo "✅ Rebuild complete. Refresh your browser."
  echo "   Your book is still available at:"
  echo "🔗 ${FULL_URL}"
done
