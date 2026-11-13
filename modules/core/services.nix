{profile, username, pkgs, ...}: {
  # Services to start
  services = {
    fstrim.enable = true; # SSD Optimizer
    openssh.enable = true; # Enable SSH
    smartd = {
      enable =
        if profile == "vm"
        then false
        else true;
      autodetect = true;
    };

    cloudflare-warp.enable = true;
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };
  
  # Import configurations
  imports = [ 
    #./rclone-mount.nix (removed: personal mounts)
    ./tailscale.nix
    #./smb-mount.nix
    #./sftp-mount.nix
    ./bluetooth.nix
  ];










  # Reduce systemd service timeouts for faster shutdown
  systemd = {
    # Set lower timeout for stopping services during shutdown
    extraConfig = ''
      DefaultTimeoutStopSec=1s
      UserStopDelaySec=1s
    '';
    
    # Configure specific problematic services
    services = {
      # Fix session timeout issues
      "user@" = {
        serviceConfig = {
          TimeoutStopSec = 1;
        };
      };
    };
    
    # Fix user session scope timeout
    user.extraConfig = ''
      DefaultTimeoutStopSec=1s
    '';
    
    # Disable core dumps to speed up shutdown
    coredump.enable = false;
  };
  
  # Fix logind session handling
  services.logind = {
    killUserProcesses = true;
    extraConfig = ''
      KillExcludeUsers=root
    '';
  };
  
  # Reduce disk sync timeout
  boot.kernel.sysctl = {
    # Reduce disk sync timeout from 30s to 5s
    "vm.dirty_writeback_centisecs" = 500;
    "vm.dirty_expire_centisecs" = 500;
  };







}

