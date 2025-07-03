# flake.nix - Dead simple working environment
{
  description = "Simple MyST/Jupyter Book environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.python3Packages.jupyter-book
          pkgs.python3Packages.myst-parser
          pkgs.python3Packages.sphinx
          pkgs.python3
        ];
        
        shellHook = ''
          echo "Simple MyST environment loaded"
          echo "Python: $(python --version)"
          echo "Jupyter Book: $(jupyter-book --version)"
        '';
      };
    };
}

