{ lib, config, ... }:
let
  btrfsMounts = lib.filterAttrs (_: fs: fs.fsType == "btrfs") config.fileSystems;
in
{
  # Monthly checksum scrub. Only on hosts that actually have btrfs.
  services.btrfs.autoScrub = lib.mkIf (btrfsMounts != { }) {
    enable = true;
    interval = "monthly";
    # One mount per filesystem is enough: scrub covers every subvolume on it.
    fileSystems = [ "/" ];
  };
}
