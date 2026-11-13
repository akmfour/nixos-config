{
  lib,
  config,
  pkgs-unstable,
  ...
}:
let
  cfg = config.dev.claude-code;
in
{
  options.dev.claude-code.enable = lib.mkEnableOption "Claude Code CLI" // {
    default = true;
  };

  # From nixos-unstable: Claude Code moves fast and the stable package lags.
  # The nixpkgs build disables the self-updater; update with `nix flake update`.
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs-unstable.claude-code ];
  };
}
