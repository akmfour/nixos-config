# VS Code with extensions for the languages / tools in modules/dev, and the
# Doki Theme "Re:Zero: Emilia" light variant (white + lavender).
#
# userSettings is written by Home Manager (read-only settings.json): change
# settings here. Extensions can still be added from the UI
# (mutableExtensionsDir stays true), but anything you want to keep should go
# in the list below.
{ pkgs, ... }:
let
  doki-theme = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "unthrottled";
    name = "doki-theme";
    version = "88.1.18";
    hash = "sha256-7Ditwj7U26t3v4ofpqw/sHar6uE46E4DWVwGZjziZfM=";
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        doki-theme

        # C
        llvm-vs-code-extensions.vscode-clangd
        ms-vscode.cmake-tools
        vadimcn.vscode-lldb
        # Python
        ms-python.python
        ms-python.debugpy
        charliermarsh.ruff
        # Zig
        ziglang.vscode-zig
        # Containers / Kubernetes / Ansible
        ms-azuretools.vscode-containers
        ms-kubernetes-tools.vscode-kubernetes-tools
        redhat.ansible
        redhat.vscode-yaml
        # Nix / env
        jnoortheen.nix-ide
        mkhl.direnv
        # Misc
        tamasfe.even-better-toml
        eamodio.gitlens
      ];

      userSettings = {
        # Doki Theme: Re:Zero: Emilia (Light). Two themes share that label,
        # so select it by id.
        "workbench.colorTheme" = "e828aaae-aa8c-4084-8993-d64697146930";
        "workbench.preferredLightColorTheme" = "e828aaae-aa8c-4084-8993-d64697146930";
        "window.autoDetectColorScheme" = false;
        "window.titleBarStyle" = "custom";

        "editor.fontFamily" = "'FiraCode Nerd Font Mono', 'Noto Sans Mono CJK JP', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "terminal.integrated.fontFamily" = "'FiraCode Nerd Font Mono'";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "editor.formatOnSave" = true;
        "files.trimTrailingWhitespace" = true;
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";
        "extensions.autoUpdate" = false;

        # C: clangd does IntelliSense (needs compile_commands.json; use `bear -- make`).
        "clangd.path" = "clangd";
        "cmake.configureOnOpen" = false;

        # Python: ruff formats and lints.
        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
        };

        # Zig: use zig / zls from PATH (nix), don't download them.
        "zig.path" = "zig";
        "zig.zls.path" = "zls";
        "zig.initialSetupDone" = true;

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];

        # Ansible: lint with ansible-lint from PATH.
        "ansible.validation.lint.enabled" = true;
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
