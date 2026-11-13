# nixos-config

My NixOS configuration for several machines, managed as a flake. Used for development and learning
(Docker, Kubernetes, Ansible, Python, C, Zig) on the COSMIC desktop.

Based on [xirin-nixos](https://github.com/bintis/xirin-nixos) by Bintis Soraphyr, which is built on
[ZaneyOS](https://gitlab.com/Zaney/zaneyos). MIT licensed, see [LICENSE](LICENSE).

| Host       | Machine                                                       | Profile |
| ---------- | ------------------------------------------------------------- | ------- |
| `devops`   | Test machine, Pentium Gold 8505, UHD iGPU, multiple NICs/SFP  | `intel` |
| `latitude` | Dell Latitude 7340 2-in-1, i7-1365U, Iris Xe, DW5931e 5G WWAN | `intel` |

- nixpkgs `nixos-26.05`, home-manager `release-26.05`, kernel `linuxPackages_latest`
- User `dev`, shell fish (starship, zoxide, eza, bat, yazi)
- COSMIC + cosmic-greeter, PipeWire, Bluetooth
- fcitx5 (Wayland frontend): Mozc, Pinyin, Chewing
- Timezone `Asia/Tokyo`, locale `en_US.UTF-8` plus `zh_TW`, `zh_CN`, `ja_JP`

## Layout

```
flake.nix                 inputs, mkHost, one nixosConfigurations.<host> per machine, formatter
hosts/<host>/
  default.nix             host-only settings, stateVersion, dev.* overrides
  hardware.nix            output of nixos-generate-config (committed)
  host-packages.nix       packages for this host only
  variables.nix           browser, terminal, keyboardLayout, consoleKeyMap
profiles/<gpu>/           intel | amd | nvidia | nvidia-laptop | vm
                          imports host + drivers + core, sets drivers.*.enable
modules/core/             system modules, one feature per file
modules/drivers/          GPU / VM drivers behind drivers.<name>.enable
modules/dev/              dev tools behind dev.<name>.enable
modules/home/             Home Manager modules (loaded from modules/core/user.nix)
templates/                project templates for `nix flake init -t`
secrets/                  reserved for encrypted secrets (empty)
```

### Dev modules

All on by default except k3s. Turn one off in `hosts/<host>/default.nix`, for example
`dev.k8s.enable = false;`.

| Option                  | Provides                                                              |
| ----------------------- | --------------------------------------------------------------------- |
| `dev.common`            | git, gh, direnv + nix-direnv, nix-ld, nixd, nixfmt, jq, yq            |
| `dev.docker`            | Docker (weekly auto-prune), docker-compose, lazydocker, dive          |
| `dev.k8s`               | kubectl, helm, kustomize, k9s, kubectx, kind, k3d                     |
| `dev.k8s.k3s`           | Local single-node k3s server (default **off**; on for `devops`)       |
| `dev.ansible`           | ansible, ansible-lint                                                 |
| `dev.ansible.navigator` | ansible-navigator, ansible-builder, rootless Podman (for AAP EEs)     |
| `dev.python`            | python3, uv, ruff                                                     |
| `dev.c`                 | gcc, make, cmake, pkg-config, gdb, valgrind, clang-tools (clangd), bear |
| `dev.zig`               | zig, zls                                                              |

## Adding a new machine

1. Install NixOS and boot it. Enable flakes for the first build:

   ```sh
   nix-shell -p git
   git clone https://github.com/akmfour/nixos-config ~/nixos-config
   cd ~/nixos-config
   ```

2. Create the host directory (copy an existing one) and generate the hardware config:

   ```sh
   cp -r hosts/devops hosts/<host>
   sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware.nix
   ```

3. Edit `hosts/<host>/default.nix`:
   - Set `system.stateVersion` and `home.stateVersion` to the release this machine was
     **first installed** with. Read it from `/etc/nixos/configuration.nix`. Never change it later.
   - Remove host-specific settings you don't need (k3s, SFP comment, nixos-hardware import).

4. Edit `hosts/<host>/variables.nix` (keyboard layout, browser, terminal).

5. Add the host to `flake.nix` and choose a profile from `profiles/`:

   ```nix
   <host> = mkHost { host = "<host>"; profile = "intel"; };
   ```

6. **Run `git add`.** A flake only sees files that git tracks, so an untracked `hardware.nix` is
   "missing":

   ```sh
   git add hosts/<host> flake.nix
   ```

7. Build, then switch. The hostname has to match on the first switch, so name the target
   explicitly:

   ```sh
   nix --extra-experimental-features 'nix-command flakes' flake check
   sudo nixos-rebuild switch --flake .#<host>
   ```

8. If the user is new, set its password with `passwd` before logging out (`users.mutableUsers = true`).

`hosts/devops/hardware.nix` and `hosts/latitude/hardware.nix` start as placeholders that make the build
fail on purpose. Replace them as described in step 2.

## Daily use

```sh
nh os switch                 # rebuild + switch (flake path ~/nixos-config, host = hostname)
nh os switch --update        # nix flake update + switch
nh os boot                   # activate on next boot
nh clean all --keep 5        # GC (also runs automatically, keeps 7d / 5 generations)

nix flake update             # update all inputs (commit flake.lock afterwards)
nix flake check
nix fmt                      # format all .nix files

sudo nixos-rebuild switch --flake .#<host>   # without nh
```

fish abbreviations: `rebuild`, `update`, `cleanup`.

### Rollback

- At boot: pick an older generation in the systemd-boot menu.
- From a running system:

  ```sh
  sudo nixos-rebuild switch --rollback
  nixos-rebuild list-generations
  ```

- Revert the git commit, then `nh os switch`.

## Secrets

This repo is public. Never commit passwords, private keys, tokens, internal IPs, or VPN/proxy configs.

Today, secrets live **outside** the repo, in `~/.config/nixos-secrets/` (`chmod 600`), and modules
reference them by path at runtime, for example `credentials=/home/dev/.config/nixos-secrets/foo`.

### Adding secrets later

`secrets/` is reserved for encrypted files. When needed:

1. Add [sops-nix](https://github.com/Mic92/sops-nix) (or [agenix](https://github.com/ryantm/agenix))
   as a flake input and import its NixOS module in `mkHost`.
2. Create an age key per machine, usually derived from the SSH host key
   (`ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`), plus your personal key. List them in
   `.sops.yaml`.
3. `sops secrets/<name>.yaml` creates an encrypted file. Only the ciphertext is committed.
4. Reference it as `sops.secrets."<name>" = { };`. At runtime the decrypted file appears in
   `/run/secrets/<name>`, and it never enters `/nix/store`.

## Notes

- **WWAN (latitude):** see `hosts/latitude/wwan.nix`. `mmcli -L` should list the modem. FCC unlock is
  not enabled, and the file describes how to handle it.
- **SFP NIC (devops):** `hosts/devops/default.nix` has a commented `ixgbe allow_unsupported_sfp` hint.
- **k3s:** the kubeconfig is `/etc/rancher/k3s/k3s.yaml` (root only). Use `sudo k3s kubectl get nodes`,
  or copy the file to `~/.kube/config`.

## Project templates

Each template has a devShell and an `.envrc` with `use flake`, so direnv loads it on `cd`.

```sh
mkdir myproj && cd myproj
nix flake init -t ~/nixos-config#c        # or #zig, #python
git init && git add . && direnv allow
```
