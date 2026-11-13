{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dev.zig;
in
{
  options.dev.zig.enable = lib.mkEnableOption "Zig (zig, zls)" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zig
      zls
    ];
  };
}
