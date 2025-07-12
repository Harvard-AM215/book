# scripts/setup-notebooks.sh
#!/usr/bin/env bash
echo "Creating paired notebooks for all MyST files..."
uv run jupytext --sync content/**/*.md
echo "✅ Notebooks created! Open any .ipynb file in Jupyter Lab"
