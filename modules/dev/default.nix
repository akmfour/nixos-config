# Development tooling. Every module has a `dev.<name>.enable` switch that
# defaults to true (k3s defaults to false); turn things off per host in
# hosts/<host>/default.nix, e.g. `dev.k8s.enable = false;`.
{ ... }:
{
  imports = [
    ./common.nix
    ./docker.nix
    ./k8s.nix
    ./ansible.nix
    ./python.nix
    ./c.nix
    ./zig.nix
    ./claude-code.nix
  ];
}
