# PLACEHOLDER — replace with the real hardware config generated on this machine:
#
#   sudo nixos-generate-config --show-hardware-config > hosts/devops/hardware.nix
#   git add hosts/devops/hardware.nix
#
# Until then this host refuses to build, so it can never boot with made-up
# filesystem UUIDs.
{ ... }:
{
  assertions = [
    {
      assertion = false;
      message = "hosts/devops/hardware.nix is a placeholder. Run `sudo nixos-generate-config --show-hardware-config > hosts/devops/hardware.nix` on the machine and `git add` it.";
    }
  ];
}
