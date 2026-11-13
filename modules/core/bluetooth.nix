{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        FastConnectable = true;
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        # Battery level reporting for headsets etc.
        Experimental = true;
      };
    };
  };
}
