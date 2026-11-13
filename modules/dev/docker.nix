{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.dev.docker;
in
{
  options.dev.docker.enable = lib.mkEnableOption "Docker" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    users.users.${username}.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
      dive
    ];
  };
}
