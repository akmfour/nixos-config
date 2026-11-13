# COSMIC look: light mode, soft gray background, lavender-purple accent,
# wallpapers from ~/Pictures/wallpapers (not in this repo: put your own
# images there; every image in the folder is shown in rotation).
#
# Managed by cosmic-manager. Settings set here are rewritten on every
# switch, so change them in this file, not in COSMIC Settings.
#
# Fallback palette if the purple doesn't look right: swap `accent` for
# aqua (0.30, 0.72, 0.80) and `neutral_tint` for (0.50, 0.57, 0.60).
{ lib, username, ... }:
let
  # RON `Some(Srgb(...))` helper for cosmic-manager.
  rgb = red: green: blue: {
    __type = "optional";
    value = { inherit red green blue; };
  };
  rgba = red: green: blue: alpha: {
    __type = "optional";
    value = {
      inherit
        red
        green
        blue
        alpha
        ;
    };
  };

  wallpaperDir = "/home/${username}/Pictures/wallpapers";
in
{
  # Keep the screen reader flag off, so a stray Super+Alt+S does not stick
  # across logins (Orca itself is disabled in modules/core/desktop.nix).
  dconf.settings."org/gnome/desktop/a11y/applications".screen-reader-enabled = false;

  wayland.desktopManager.cosmic = {
    enable = true;

    appearance = {
      theme.mode = "light";

      theme.light = {
        accent = rgb 0.608 0.42 0.875; # #9B6BDF, matches Doki "Emilia Light"
        bg_color = rgba 0.957 0.949 0.969 1.0; # #F4F2F7 soft gray
        neutral_tint = rgb 0.549 0.529 0.58; # #8C8794 gray with a hint of lavender
      };

      # Also theme GTK apps with the COSMIC palette.
      toolkit.apply_theme_global = true;
    };

    wallpapers = [
      {
        output = "all";
        source = {
          __type = "enum";
          variant = "Path";
          value = [ wallpaperDir ];
        };
        filter_by_theme = false;
        filter_method = {
          __type = "enum";
          variant = "Lanczos";
        };
        scaling_mode = {
          __type = "enum";
          variant = "Zoom";
        };
        sampling_method = {
          __type = "enum";
          variant = "Random";
        };
        rotation_frequency = 900; # seconds
      }
    ];
  };

  # cosmic-manager writes the theme Builder as v2, but COSMIC 1.2 still reads
  # Builder v1, so the accent/background were silently ignored. Pin it to v1;
  # drop this once COSMIC itself moves to Builder v2.
  wayland.desktopManager.cosmic.configFile."com.system76.CosmicTheme.Light.Builder".version =
    lib.mkForce 1;

  # Make sure the folder exists so COSMIC has something to point at.
  systemd.user.tmpfiles.rules = [ "d ${wallpaperDir} 0755 - - -" ];
}
