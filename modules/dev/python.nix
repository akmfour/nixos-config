{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dev.python;
in
{
  options.dev.python.enable = lib.mkEnableOption "Python (python3, uv, ruff)" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python3
      uv
      ruff
    ];
  };
}
