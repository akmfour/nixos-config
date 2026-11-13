{ pkgs, username, ... }:
{
  # KVM/QEMU virtual machines managed through libvirt, with virt-manager as the GUI.
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true; # TPM 2.0 for Windows 11 guests
  };
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  users.users.${username}.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    # Windows programs. The WoW64 build runs both 32- and 64-bit .exe files.
    wineWow64Packages.stable
    winetricks
  ];
}
