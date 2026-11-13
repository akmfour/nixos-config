{ username, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Must match the NixOS release this machine was FIRST installed with
  # (see `system.stateVersion` in its original /etc/nixos/configuration.nix).
  # Never bump it on upgrades.
  system.stateVersion = "26.05";
  home-manager.users.${username}.home.stateVersion = "26.05";
}
