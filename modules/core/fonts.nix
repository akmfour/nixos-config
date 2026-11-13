{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      font-awesome
      material-icons
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
      ];
      monospace = [
        "FiraCode Nerd Font Mono"
        "Noto Sans Mono CJK JP"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
