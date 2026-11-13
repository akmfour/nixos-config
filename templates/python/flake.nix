{
  description = "Python project (uv)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3
              uv
              ruff
            ];
            env = {
              # Use the Nix-provided interpreter instead of downloading one.
              UV_PYTHON_DOWNLOADS = "never";
              UV_PYTHON = "${pkgs.python3}/bin/python3";
            };
          };
        }
      );
    };
}
