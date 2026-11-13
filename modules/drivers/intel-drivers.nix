{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = lib.mkEnableOption "Intel graphics drivers";
  };

  config = lib.mkIf cfg.enable {
    # Gen12+ iGPUs (Alder Lake / Raptor Lake): VA-API via intel-media-driver
    # (iHD) and oneVPL (Quick Sync) via vpl-gpu-rt. The old
    # intel-vaapi-driver (i965, formerly `vaapiIntel`) only covers <= Gen9.
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      libvdpau-va-gl
    ];
    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };
}
