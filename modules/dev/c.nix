{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dev.c;
in
{
  options.dev.c.enable = lib.mkEnableOption "C toolchain (gcc, make, cmake, gdb, clangd, ...)" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      gnumake
      cmake
      pkg-config
      gdb
      valgrind
      clang-tools # clangd, clang-format, clang-tidy
      bear # generates compile_commands.json for clangd
    ];
  };
}
