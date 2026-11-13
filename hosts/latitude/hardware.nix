# PLACEHOLDER — replace with the real hardware config generated on this machine:
#
#   sudo nixos-generate-config --show-hardware-config > hosts/latitude/hardware.nix
#   git add hosts/latitude/hardware.nix
#
# Until then this host refuses to build, so it can never boot with made-up
# filesystem UUIDs.
{ ... }:
{
  assertions = [
    {
      assertion = false;
      message = "hosts/latitude/hardware.nix is a placeholder. Run `sudo nixos-generate-config --show-hardware-config > hosts/latitude/hardware.nix` on the machine and `git add` it.";
    }
  ];
}
