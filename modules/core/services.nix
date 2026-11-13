{ profile, ... }:
{
  services = {
    fstrim.enable = true;
    fwupd.enable = true; # firmware updates: `fwupdmgr refresh && fwupdmgr update`
    printing.enable = true;
    # mDNS: finds network printers (IPP Everywhere / AirPrint) without drivers.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    smartd = {
      enable = profile != "vm";
      autodetect = true;
    };
  };

  # Shutdown / stop timeouts: systemd defaults on purpose. The template's
  # 1s timeouts could kill services before they finished writing data.
}
