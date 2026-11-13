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
      ];
      # Preset input method group: keyboard, Mozc, Pinyin.
      # Defaults on a fresh home; an existing ~/.config/fcitx5 takes precedence.
      settings.globalOptions = {
        # Alt+Shift toggles the input method (fcitx5 default is Ctrl+Space).
        "Hotkey/TriggerKeys" = {
          "0" = "Alt+Shift+Shift_L";
          "1" = "Zenkaku_Hankaku";
          "2" = "Hangul";
        };
      };
      # Pinyin outputs Traditional Chinese (OpenCC). Ctrl+Shift+F toggles it.
      settings.addons.chttrans = {
        globalSection = {
          Engine = "OpenCC";
          OpenCCS2TProfile = "default";
          OpenCCT2SProfile = "default";
        };
        sections = {
          Hotkey."0" = "Control+Shift+F";
          EnabledIM."0" = "pinyin";
        };
      };
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
      };
    };
  };

  environment.variables = {
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # GLFW only speaks the ibus protocol; fcitx5 emulates it
  };
}
