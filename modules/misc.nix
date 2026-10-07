{ pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.uinput.enable = true;
  services.udev.extraRules = ''
        KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="plugdev", MODE="0660"
    # charachorder
        SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="8253", MODE="0660", GROUP="dialout", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="8253", MODE="0666", GROUP="dialout"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="8253", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="8253", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "de_DE.UTF-8/UTF-8" ];
  hardware.gpgSmartcards.enable = true;

  users.mutableUsers = true;

  services.openssh.enable = true;
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ ];
  services.fwupd.enable = true;

  hardware.keyboard.qmk.enable = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.epkowa ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.registries.settings = {
      unqualified-search-registries = [
        "docker.io"
      ];
      short-name-mode = "permissive";
    };
  };

  networking.firewall.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      brlaser
    ];
  };
  services.ipp-usb.enable = true;
}
