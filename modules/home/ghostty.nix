# Ghostty with a light lavender palette that matches the COSMIC theme and
# the Doki "Emilia Light" VS Code theme (ANSI colors darkened a bit so they
# stay readable on a light background).
{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    themes.emilia-light = {
      background = "f8f5fb";
      foreground = "4d4d4a";
      cursor-color = "9b6bdf";
      cursor-text = "f8f5fb";
      selection-background = "e7d8ee";
      selection-foreground = "4d4d4a";
      palette = [
        "0=#4d4d4a"
        "1=#d6409a"
        "2=#2f9e4f"
        "3=#c98a2e"
        "4=#7a4fcf"
        "5=#b04fc7"
        "6=#2a9fb8"
        "7=#a8a3ad"
        "8=#7a7680"
        "9=#e356a7"
        "10=#38b85c"
        "11=#e09a45"
        "12=#9b6bdf"
        "13=#c77ddb"
        "14=#4fbfd6"
        "15=#d9d4de"
      ];
    };

    settings = {
      theme = "emilia-light";
      font-family = [
        "FiraCode Nerd Font Mono"
        "Noto Sans Mono CJK JP"
      ];
      font-size = 12;
      window-padding-x = 8;
      window-padding-y = 6;
      background-opacity = 0.97;
    };
  };
}
