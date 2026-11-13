# Test / dev machine — Intel Pentium Gold 8505 (Alder Lake), UHD iGPU,
# 16 GB, several NICs including SFP. UEFI.
{ inputs, username, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only # microcode
  ];

  # All NICs are handled by NetworkManager with DHCP (modules/core/network.nix).
  #
  # SFP NIC: if it is an Intel X520/X710 (ixgbe / i40e) and a third-party
  # SFP+ module is refused ("unsupported SFP+ module type" in dmesg), allow it:
  # boot.extraModprobeConfig = "options ixgbe allow_unsupported_sfp=1";

  # Local single-node k3s for experiments.
  dev.k8s.k3s.enable = true;

  # Must match the NixOS release this machine was FIRST installed with
  # (see `system.stateVersion` in its original /etc/nixos/configuration.nix).
  # Never bump it on upgrades.
  system.stateVersion = "26.05";
  home-manager.users.${username}.home.stateVersion = "26.05";
}
