# flake.nix - Quiet version
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
        nodejs # required by juppyter-book
      ];

      # No shellHook = no output
    };
  };
}
