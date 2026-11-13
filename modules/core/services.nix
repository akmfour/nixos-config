{ profile, ... }:
{
  services = {
    fstrim.enable = true;
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
