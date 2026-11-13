{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) keyboardLayout;
in
{
  # Only the XKB layout is used (COSMIC reads it); no X server.
  services.xserver = {
    enable = false;
    xkb = {
      layout = keyboardLayout;
      variant = "";
    };
  };
}
