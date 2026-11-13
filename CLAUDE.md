# CLAUDE.md

Personal multi-host NixOS flake. Based on xirin-nixos / ZaneyOS. See README.md for layout and commands.
The user writes in Chinese: answer in Chinese.

## Hard rules

- **The repo is PUBLIC.** Never commit passwords, keys, tokens, internal IPs, VPN/proxy configs, or
  copyrighted images (wallpapers live in `~/Pictures/wallpapers`, outside the repo).
- A flake only sees git-tracked files: `git add` new files before building.
- Never change `system.stateVersion` / `home.stateVersion` (both `26.05`).
- Build with no evaluation warnings. Run `nix fmt` before committing.
- Commit per logical change, with a clear message. Ask before pushing.
- Prefer `nh os build` / `nixos-rebuild build --flake .#<host>` before `switch`. Changes to the display
  manager or boot need `nh os boot` + reboot, not `switch`.

## Facts

- Hosts: `devops` (test machine: Pentium Gold 8505, UHD iGPU, 4x I226-V, UEFI, btrfs) and
  `latitude` (Dell Latitude 7340 2-in-1, installed, real `hardware.nix`).
- latitude WWAN: MediaTek T700 (`14c3:4d75`, driver `mtk_t7xx`, MBIM). COSMIC 1.2 has no mobile
  broadband UI, so `nm-applet --indicator` provides the toggle/APN wizard and ModemManager starts at
  boot (`hosts/latitude/wwan.nix`). Modem, driver and ModemManager work. SIM slot 1 = physical tray
  (empty), slot 2 = eSIM. The user plans to use eSIM but has no carrier profile yet, so `mmcli -m 0`
  shows `failed: sim-missing` and nmcli shows `unavailable`; that is expected, not a fault. When the
  activation code arrives: `lpac` (installed) to download the profile, switch to slot 2, add APN.
- User `dev`, shell fish. nixpkgs `nixos-26.05`; `pkgs-unstable` (nixos-unstable) only for vscode
  and claude-code.
- Desktop COSMIC + cosmic-greeter. The user does NOT want SDDM. Animated login/lock backgrounds are
  not supported by COSMIC yet (planned for epoch 3), and that is accepted.
- COSMIC look is managed by cosmic-manager in `modules/home/cosmic.nix`. Wanted: light mode, gray +
  purple (aqua as fallback). The user chose to manage all of it declaratively.
- Input method: fcitx5 with waylandFrontend, Mozc + Pinyin, layout `us`
  (`modules/core/input-method.nix`).

## Open issues (investigate on this machine)

None right now.

## Resolved

- **Typing turned into shortcuts**: not fcitx5. The Orca screen reader was on
  (`screen-reader-enabled`, toggled by Super+Alt+S) and took letter keys as navigation commands.
  Fixed by `services.orca.enable = false` (`modules/core/desktop.nix`) and a dconf override in
  `modules/home/cosmic.nix`. If keys act up again, check `dconf read
  /org/gnome/desktop/a11y/applications/screen-reader-enabled` first.
- **COSMIC accent/colors not applied**: cosmic-manager writes `Light.Builder` as v2, COSMIC 1.2
  reads v1. Pinned to v1 with `lib.mkForce 1` in `modules/home/cosmic.nix`; remove the pin when
  COSMIC moves to Builder v2 (then the v1 dir goes stale instead).
