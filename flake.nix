{
  description = "Multi-host NixOS configuration (based on xirin-nixos / ZaneyOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Only for individual packages that are broken or too old on stable
    # (exposed as `pkgs-unstable`). Currently: vscode, claude-code.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative COSMIC settings (theme, wallpaper) for Home Manager.
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      # Only its modules are used; don't fetch a second nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "dev";

      # One nixosConfiguration per host. `host` selects hosts/<host>/,
      # `profile` selects profiles/<profile>/ (GPU / VM drivers).
      mkHost =
        { host, profile }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              username
              host
              profile
              ;
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./profiles/${profile}
          ];
        };
    in
    {
      # `nix fmt` formats every .nix file in the repo.
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      # nix flake init -t ~/nixos-config#<name>
      templates = {
        c = {
          path = ./templates/c;
          description = "C project: make, cmake, gdb, valgrind, clangd, bear";
        };
        zig = {
          path = ./templates/zig;
          description = "Zig project: zig, zls";
        };
        python = {
          path = ./templates/python;
          description = "Python project: python3, uv, ruff";
        };
      };

      nixosConfigurations = {
        devops = mkHost {
          host = "devops";
          profile = "intel";
        };
        latitude = mkHost {
          host = "latitude";
          profile = "intel";
        };
      };
    };
}
