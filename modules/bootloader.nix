{ pkgs, ... }:
{
  # TODO rename to linux defaults?

  zramSwap.enable = true;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  boot = {
    # bootspec.enabled = true;
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth = {
      enable = false;
    };
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
}
