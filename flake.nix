{
  description = "devops's NixOS configuration (based on xirin-nixos / ZaneyOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "devops";

      # One nixosConfiguration per host. `host` selects hosts/<host>/,
      # `profile` selects profiles/<profile>/ (GPU / VM drivers).
      mkHost =
        { host, profile }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              username
              host
              profile
              ;
          };
          modules = [ ./profiles/${profile} ];
        };
    in
    {
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
