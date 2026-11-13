{ ... }:
{
  imports = [
    ./boot.nix
    ./bluetooth.nix
    ./desktop.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware.nix
    ./input-method.nix
    ./network.nix
    ./nh.nix
    ./packages.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
    ./xserver.nix
    ../dev
  ];
}
