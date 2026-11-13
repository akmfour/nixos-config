{ pkgs, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) keyboardLayout;
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Native Wayland input method frontend. With this on, the NixOS module
      # deliberately does not set GTK_IM_MODULE / QT_IM_MODULE.
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc # Japanese
        qt6Packages.fcitx5-chinese-addons # Pinyin / Shuangpin / tables
        fcitx5-chewing # Zhuyin (Bopomofo)
      ];
      # Preset input method group: keyboard, Mozc, Pinyin, Chewing.
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = keyboardLayout;
          DefaultIM = "mozc";
        };
        "Groups/0/Items/0".Name = "keyboard-${keyboardLayout}";
        "Groups/0/Items/1".Name = "mozc";
        "Groups/0/Items/2".Name = "pinyin";
        "Groups/0/Items/3".Name = "chewing";
      };
    };
  };

  environment.variables = {
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # GLFW only speaks the ibus protocol; fcitx5 emulates it
  };
}
