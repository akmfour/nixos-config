{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dev.common;
in
{
  options.dev.common.enable = lib.mkEnableOption "common dev tools (git, gh, direnv, nix-ld)" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;

    # direnv + nix-direnv: `use flake` in .envrc loads a project devShell.
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Lets prebuilt, dynamically linked binaries (uv-managed Pythons, zig
    # downloads, VS Code servers, ...) find a loader and common libraries.
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      gh
      jq
      yq-go
      nixd
      nixfmt
    ];
  };
}
