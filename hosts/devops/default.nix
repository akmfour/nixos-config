{ ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  networking.hostName = "devops";
}
