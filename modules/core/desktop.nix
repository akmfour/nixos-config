{ ... }:
{
  # COSMIC desktop + greeter (replaces whatever DE the installer set up).
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # No Orca screen reader. The COSMIC module enables it by default and
  # cosmic-session starts it at login. Once it gets switched on (Super+Alt+S
  # is easy to hit by accident), Orca treats plain letter keys as its own
  # navigation commands, so typing turns into shortcuts.
  services.orca.enable = false;

  # Electron / Chromium (Brave) apps run natively on Wayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Audio: PipeWire with PulseAudio/ALSA compatibility.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
