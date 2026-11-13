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

- Hosts: `devops` (this test machine: Pentium Gold 8505, UHD iGPU, 4x I226-V, UEFI, btrfs) and
  `latitude` (Dell Latitude 7340 2-in-1, not installed yet, `hosts/latitude/hardware.nix` is a
  placeholder that fails the build on purpose).
- User `dev`, shell fish. nixpkgs `nixos-26.05`; `pkgs-unstable` (nixos-unstable) only for vscode
  and claude-code.
- Desktop COSMIC + cosmic-greeter. The user does NOT want SDDM. Animated login/lock backgrounds are
  not supported by COSMIC yet (planned for epoch 3), and that is accepted.
- COSMIC look is managed by cosmic-manager in `modules/home/cosmic.nix`. Wanted: light mode, gray +
  purple (aqua as fallback). The user chose to manage all of it declaratively.
- Input method: fcitx5 with waylandFrontend, Mozc + Pinyin + Chewing, layout `us`
  (`modules/core/input-method.nix`).

## Open issues (investigate on this machine)

1. **Keyboard input turns into shortcuts while typing** (top priority). The cause is probably an
   interaction between fcitx5 and COSMIC (or fcitx5 hotkeys). Known cosmic-comp IME bugs:
   pop-os/cosmic-comp#2952 (Electron apps swallow keys), #2947 (text-input-v3 swallows keys with
   pinyin), #1763. Find out which app, which IM, which keys, and whether `keyboard-us` alone
   reproduces it. Check `fcitx5-diagnose`, `~/.config/fcitx5/config` (hotkeys), and stuck
   modifiers (`wev` / `libinput debug-events` are useful).
2. **COSMIC accent/colors not applied** (the wallpaper is). Check
   `~/.config/cosmic/com.system76.CosmicTheme.{Mode,Light.Builder,Light}/`, the version dirs
   (cosmic-manager writes Builder v2), whether `cosmic-ext-ctl build-theme` ran
   (`journalctl -b -u home-manager-dev.service`), and the light vs dark mode.
3. **flake.lock** has local changes (cosmic-manager + nixpkgs-unstable inputs added) that still
   need to be committed.
