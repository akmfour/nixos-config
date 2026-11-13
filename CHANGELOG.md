# CHANGELOG

## 2026-11-13 — IDE and theme

- VS Code (Home Manager) with extensions for C, Python, Zig, containers,
  Kubernetes, Ansible, Nix; Doki Theme "Re:Zero: Emilia" (light).
- COSMIC via cosmic-manager: light mode, soft gray background, lavender
  purple accent, wallpapers rotated from ~/Pictures/wallpapers (not in repo).
- Ghostty with a matching light lavender palette.

## 2026-11-13 — initial multi-host setup

Forked from [xirin-nixos](https://github.com/bintis/xirin-nixos) (ZaneyOS +
COSMIC) and reworked for two machines.

- Multi-host flake: `mkHost { host; profile; }`, hosts `devops` and `latitude`.
- nixpkgs `nixos-26.05`, home-manager `release-26.05`, `linuxPackages_latest`.
- Removed the template author's personal settings (static IP, firewall off,
  network mounts, warp, tailscale, syncthing, steam, QQ, Windsurf, Chrome,
  Zed, OBS, v4l2loopback, Hyprland cache, Rust overlay/devShell).
- Safer defaults: no `mitigations=off` / `fsck.mode=skip` /
  `usbcore.autosuspend=-1`, systemd default stop timeouts, coredumps on.
- AMD-only kernel params moved into the AMD driver module.
- fish instead of zsh/bash; Brave instead of Chrome.
- fcitx5: Mozc + Pinyin + Chewing (Rime removed), Wayland frontend.
- CJK fonts and zh_TW / zh_CN / ja_JP locales.
- `modules/dev/`: docker, k8s (+ optional k3s), ansible (+ navigator/podman),
  python, c, zig, common (direnv, nix-ld).
- latitude: nixos-hardware laptop modules, ppd + thermald, fwupd, iio
  sensor, ModemManager for the 5G modem.
- `nix fmt` via nixfmt-tree; `secrets/` reserved.

## 2025-07-13 (xirin-nixos)

Say goodbye to Hyprland and hello to Cosmic-DE.
