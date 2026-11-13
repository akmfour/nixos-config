{ ... }:
{
  # COSMIC desktop + greeter (replaces whatever DE the installer set up).
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

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
