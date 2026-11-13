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
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "zh_TW.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  console.keyMap = consoleKeyMap;

  # system.stateVersion is set per host in hosts/<host>/default.nix.
}
