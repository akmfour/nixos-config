{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    shellAbbrs = {
      rebuild = "nh os switch";
      update = "nh os switch --update";
      cleanup = "nh clean all";
    };
  };
}
