# flake.nix
cat > flake.nix << 'EOF'
{
  description = "Working MyST environment";

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
        packages = with pkgs; [
          (python3.withPackages (ps: with ps; [
            jupyter-book
            myst-parser
            sphinx
            sphinx-book-theme
          ]))
        ];
      };
    };
}
EOF

# .envrc
echo "use flake" > .envrc

# _config.yml
cat > _config.yml << 'EOF'
title: "Test Book"
author: "Me"
EOF

# _toc.yml
cat > _toc.yml << 'EOF'
format: jb-book
root: index
EOF

# index.md
cat > index.md << 'EOF'
# Test Book

This is a test.
EOF
