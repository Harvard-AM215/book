# flake.nix - Include libraries for uv compatibility
{
  description = "AM215 Course Materials";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "am215-book";
      packages = with pkgs; [
        python311
        uv
        git
        nodejs

        # System libraries for Python packages
        stdenv.cc.cc.lib
        zlib
        libffi
        zeromq
      ];

      shellHook = ''
        export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.libffi}/lib:${pkgs.zeromq}/lib:$LD_LIBRARY_PATH"
        export UV_PYTHON_DOWNLOADS=never
        export UV_PYTHON_PREFERENCE=system
      '';
    };
  };
}
