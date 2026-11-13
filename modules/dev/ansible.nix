{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dev.ansible;
in
{
  options.dev.ansible = {
    enable = lib.mkEnableOption "Ansible" // {
      default = true;
    };
    navigator.enable = lib.mkEnableOption "ansible-navigator + Podman for AAP execution environments" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          ansible
          ansible-lint
        ];
      }

      (lib.mkIf cfg.navigator.enable {
        # Rootless Podman runs the execution-environment images. Docker
        # stays the `docker` command; Podman does not take over its socket.
        virtualisation.podman = {
          enable = true;
          dockerCompat = false;
          dockerSocket.enable = false;
          defaultNetwork.settings.dns_enabled = true;
        };
        environment.systemPackages = with pkgs; [
          ansible-navigator
          ansible-builder
        ];
      })
    ]
  );
}
