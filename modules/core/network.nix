{ host, lib, ... }:
{
  networking = {
    hostName = lib.mkDefault host;
    # DHCP on every interface via NetworkManager. No static IPs or
    # interface names in this public repo.
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Don't block boot waiting for the network.
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
}
