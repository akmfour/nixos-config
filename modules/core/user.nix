{
  pkgs,
  pkgs-unstable,
  inputs,
  username,
  host,
  profile,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit
        inputs
        pkgs-unstable
        username
        host
        profile
        ;
    };
    users.${username} = {
      imports = [
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
        ./../home
      ];
      home = {
        username = username;
        homeDirectory = "/home/${username}";
        # home.stateVersion is set per host in hosts/<host>/default.nix.
      };
    };
  };

  programs.fish.enable = true;

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "lp"
      "networkmanager"
      "scanner"
      "wheel"
    ];
    shell = pkgs.fish;
  };
  nix.settings.allowed-users = [ username ];
}
