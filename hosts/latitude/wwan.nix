# Dell DW5931e 5G WWAN modem.
#
# Check that ModemManager sees it:
#   mmcli -L              # list modems
#   mmcli -m 0            # details; look at "state" and any "fcc-locked" note
#   nmcli connection add type gsm ifname '*' con-name wwan apn <your-apn>
#
# FCC lock: many M.2 WWAN cards ship "FCC locked" and stay in low-power
# mode until an unlock sequence is sent. ModemManager ships unlock scripts
# for a few vid:pid pairs, but NONE are enabled by default here on purpose
# (enabling one is your decision; check the vendor's terms first).
#
# If `mmcli -m 0` reports the modem as FCC locked:
#   1. Find its PCI id:  lspci -nn | grep -i -e wwan -e modem -e qualcomm -e mediatek
#   2. See whether ModemManager has a script for that id:
#        ls $(nix eval --raw nixpkgs#modemmanager)/share/ModemManager/fcc-unlock.available.d/
#   3. If it does, enable it (replace vid:pid):
#        networking.modemmanager.fccUnlockScripts = [
#          {
#            id = "vid:pid";
#            path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/vid:pid";
#          }
#        ];
#   4. If there is no script, Dell's own unlock tool for Linux is the
#      remaining option; it is not packaged here.
#
# eSIM: slot 1 is the physical SIM tray, slot 2 the built-in eSIM.
# `lpac` downloads carrier profiles over MBIM (through ModemManager's proxy):
#   export LPAC_APDU=mbim LPAC_APDU_MBIM_DEVICE=/dev/wwan0mbim0 LPAC_APDU_MBIM_USE_PROXY=1
#   lpac chip info
#   lpac profile download -a 'LPA:1$<smdp>$<matching-id>'
#   lpac profile list; lpac profile enable <iccid>
# Then make slot 2 active (`mmcli -m 0 --set-primary-sim-slot=2`) and add the
# APN connection (nm-applet wizard or `nmcli connection add type gsm ...`).
{ pkgs, ... }:
{
  networking.modemmanager.enable = true;

  # Start ModemManager at boot. Upstream only D-Bus-activates it, so it
  # stays down until something asks for it and a new SIM may not show up.
  # Cheap: the modem itself stays PCI runtime-suspended while idle.
  systemd.services.ModemManager.wantedBy = [ "multi-user.target" ];

  # COSMIC 1.2's network applet has no mobile broadband UI (WWAN is only
  # touched by airplane mode). nm-applet in the status area gives an
  # "Enable Mobile Broadband" toggle and the new-connection (APN) wizard.
  programs.nm-applet = {
    enable = true;
    indicator = true; # StatusNotifierItem, shown in COSMIC's status area
  };

  environment.systemPackages = with pkgs; [
    libqmi # qmicli
    libmbim # mbimcli
    lpac # eSIM profile manager (LPA)
    modem-manager-gui
  ];
}
