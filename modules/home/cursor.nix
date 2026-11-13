{ pkgs, ... }: {
  # Configure cursor theme for COSMIC DE
  home.pointerCursor = {
    name = "Bibata-Modern-Ice"; # You can change this to any cursor theme you prefer
    package = pkgs.bibata-cursors;
    size = 24; # You can adjust the size as needed
    gtk.enable = true;
    x11.enable = true;
  };

  # Set environment variables for COSMIC DE
  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };
}
