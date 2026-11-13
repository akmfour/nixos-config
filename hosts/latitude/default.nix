# Dell Latitude 7340 2-in-1 — i7-1365U (Raptor Lake), Intel Iris Xe, 16 GB,
# Dell DW5931e 5G WWAN, touchscreen, convertible.
{ inputs, username, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./wwan.nix
    # nixos-hardware has no latitude-7340 module; use the generic ones.
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Gen12 iGPU: only the iHD driver (nixos-hardware would add i965 too).
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  # Power: power-profiles-daemon + thermald. Enabling ppd also keeps
  # nixos-hardware's common-pc-laptop from turning on TLP.
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  services.fwupd.enable = true;

  # 2-in-1: accelerometer for automatic screen rotation.
  hardware.sensor.iio.enable = true;

  # Use kind / k3d for Kubernetes here, not a resident k3s.
  dev.k8s.k3s.enable = false;

  # Must match the NixOS release this machine was FIRST installed with.
  # Never bump it on upgrades.
  system.stateVersion = "26.05";
  home-manager.users.${username}.home.stateVersion = "26.05";
}
