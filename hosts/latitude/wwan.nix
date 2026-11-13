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
{ pkgs, ... }:
{
  networking.modemmanager.enable = true;

  environment.systemPackages = with pkgs; [
    libqmi # qmicli
    libmbim # mbimcli
    modem-manager-gui
  ];
}
