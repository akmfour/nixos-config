# Test / dev machine — Intel Pentium Gold 8505 (Alder Lake), UHD iGPU,
# 16 GB, 4x Intel I226-V 2.5GbE. UEFI.
{ inputs, username, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only # microcode
  ];

  # NICs: 4x Intel I226-V 2.5GbE (igc driver, in-tree). All handled by
  # NetworkManager with DHCP (modules/core/network.nix). No SFP controller
  # shows up in lspci.

  # Local single-node k3s for experiments.
  dev.k8s.k3s.enable = true;

  # Must match the NixOS release this machine was FIRST installed with
  # (see `system.stateVersion` in its original /etc/nixos/configuration.nix).
  # Never bump it on upgrades.
  system.stateVersion = "26.05";
  home-manager.users.${username}.home.stateVersion = "26.05";
}
