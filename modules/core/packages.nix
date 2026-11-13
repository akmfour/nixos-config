{ pkgs, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) browser terminal;
in
{
  programs = {
    firefox.enable = false;
    dconf.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.BROWSER = browser;

  environment.systemPackages = with pkgs; [
    pkgs.${browser}
    pkgs.${terminal}
    android-tools # adb / fastboot (programs.adb was removed in 25.11)
    ffmpeg
    inxi
    killall
    lm_sensors
    lshw
    mpv
    onefetch
    pciutils
    remmina
    ripgrep
    sox
    unrar
    unzip
    usbutils
    v4l-utils
    wget
  ];
}
