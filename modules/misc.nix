{ pkgs, ... }:

{
  hardware.enableAllFirmware = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  hardware.gpgSmartcards.enable = true;

  users.mutableUsers = true;

  services.openssh.enable = false;
  services.fwupd.enable = true;

  hardware.keyboard.qmk.enable = true;
  
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.firewall.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
