{ pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  system.autoUpgrade.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  environment.systemPackages = with pkgs; [
    libwacom
    curl
    git
    neovim
    python3
    gcc-arm-embedded
    dfu-util
    qmk
    gnumake
    # currently we need to decide between, which is a bit annoying
    #   clang
    gcc
    ripgrep
    file
    fd
    less
    pass
    clang-tools
    rustup
    nodejs
    nil
    jq
    stylua
    lua-language-server
    typos
    python311Packages.huggingface-hub
    llm-ls
    distrobox
    #ollama
    pyright
    docker-compose

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware.gpgSmartcards.enable = true;
  hardware.pulseaudio.enable = false;
  # move to editor
  #programs.neovim.enable = true;

  users.mutableUsers = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  hardware.keyboard.qmk.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    # podman = {
    #   enable = true;
    #   # Create a `docker` alias for podman, to use it as a drop-in replacement
    #   dockerCompat = true;
    #   # Required for containers under podman-compose to be able to talk to each other.
    #   defaultNetwork.settings.dns_enabled = true;
    # };
    docker.enable = true;
  };

  # exclude to k3s.nix  
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
