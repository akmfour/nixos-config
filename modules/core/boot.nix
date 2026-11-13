{ pkgs, lib, ... }:
{
  boot = {
    # Newest mainline kernel by default; a host can override this with a
    # plain `boot.kernelPackages = ...;` in hosts/<host>/default.nix.
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    # Quiet boot with the firmware (BGRT) logo. Machine-specific or
    # risky parameters (GPU options, mitigations=off, fsck.mode=skip,
    # usbcore.autosuspend=-1) intentionally do not live here.
    kernelParams = [
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "loglevel=3"
      "vt.global_cursor_default=0"
      "splash"
    ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.systemd.enable = true;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };
}
