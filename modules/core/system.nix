{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) consoleKeyMap;
in
{
  nix.settings = {
    download-buffer-size = 250000000;
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = consoleKeyMap;

  # system.stateVersion is set per host in hosts/<host>/default.nix.
}
