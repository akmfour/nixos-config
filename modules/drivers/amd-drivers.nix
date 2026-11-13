{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = lib.mkEnableOption "AMD GPU drivers";
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    # Early KMS, and use amdgpu instead of radeon for SI/CIK cards.
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelParams = [
      "radeon.si_support=0"
      "radeon.cik_support=0"
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
    ];
  };
}
