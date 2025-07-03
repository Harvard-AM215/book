# flake.nix - For Nix users
{
  description = "AM215 Course Materials Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Python with all MyST dependencies
        python-with-deps = pkgs.python3.withPackages (ps: with ps; [
          # Core MyST tools
          jupyter-book
          myst-parser
          myst-nb
          sphinx
          sphinx-book-theme
          sphinx-external-toc
          
          # Scientific computing
          numpy
          matplotlib
          scipy
          sympy
          pandas
          seaborn
          plotly
          
          # Jupyter ecosystem
          jupyter
          jupytext
          ipykernel
          ipywidgets
          
          # Development tools
          black
          isort
          flake8
          mypy
          
          # Additional useful packages
          requests
          pyyaml
          watchdog  # For auto-rebuild
        ]);
        
        # Build script
        build-script = pkgs.writeShellScriptBin "build-book" ''
          echo "Building MyST book..."
          jupyter-book build . --all
          echo "Build complete! Open _build/html/index.html"
        '';
        
        # Watch script for auto-rebuild
        watch-script = pkgs.writeShellScriptBin "watch-book" ''
          echo "Watching for changes..."
          watchmedo shell-command \
            --patterns="*.md;*.py;*.ipynb;*.yml;*.yaml;*.bib" \
            --recursive \
            --command='jupyter-book build . --all' \
            --wait \
            content/
        '';
        
        # Clean script
        clean-script = pkgs.writeShellScriptBin "clean-book" ''
          echo "Cleaning build artifacts..."
          rm -rf _build .jupyter_cache
          echo "Clean complete!"
        '';
        
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python-with-deps
            build-script
            watch-script
            clean-script
            
            # Additional tools
            git
            nodejs  # For some Jupyter extensions
            pandoc  # For format conversion
            texlive.combined.scheme-medium  # For PDF generation
            
            # Optional: VS Code server for remote development
            # code-server
          ];
          
          shellHook = ''
            echo "🚀 AM215 Course Materials Development Environment"
            echo "Available commands:"
            echo "  build-book  - Build the MyST book"
            echo "  watch-book  - Watch for changes and auto-rebuild"
            echo "  clean-book  - Clean build artifacts"
            echo "  jupyter lab - Start Jupyter Lab"
            echo ""
            echo "Python path: $(which python)"
            echo "MyST version: $(python -c 'import myst_parser; print(myst_parser.__version__)')"
          '';
        };
        
        # For CI/CD
        packages.default = pkgs.stdenv.mkDerivation {
          name = "am215-course-materials";
          src = ./.;
          buildInputs = [ python-with-deps ];
          buildPhase = ''
            jupyter-book build . --all
          '';
          installPhase = ''
            mkdir -p $out
            cp -r _build/html/* $out/
          '';
        };
      });
}

# .envrc - Direnv configuration (works with flake)
if command -v nix &> /dev/null && [ -f flake.nix ]; then
  echo "Using Nix flake environment..."
  use flake
elif command -v uv &> /dev/null && [ -f pyproject.toml ]; then
  echo "Using uv environment..."
  layout python
  uv sync
  export VIRTUAL_ENV=$(uv venv --python 3.11 --quiet --seed .venv && echo .venv)
  PATH_add $VIRTUAL_ENV/bin
elif [ -f requirements.txt ]; then
  echo "Using venv environment..."
  layout python3
  pip install -r requirements.txt
else
  echo "No suitable environment found. Please run setup script."
fi

# Add project scripts to PATH
PATH_add scripts/