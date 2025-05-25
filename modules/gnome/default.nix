{ pkgs, inputs, enable_gdm ? true, ... }:
{

  environment.systemPackages = with pkgs; [
    xdg-utils
    pavucontrol
    xdg-desktop-portal-gnome
    pamixer
    librewolf
    # needed for characorder
    chromium
    playerctl
    xwayland-satellite
    signal-desktop
    element-desktop
    shortwave
    wl-clipboard
    vlc
    evolution
  ];

  environment.gnome.excludePackages = (with pkgs; [
    atomix # puzzle game
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-characters
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);

  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-utilities.enable = true;
  services.gnome.gnome-remote-desktop.enable = false;
  services.flatpak.enable = true;

  security.pam.services.swaylock = { };
  programs.niri = {
    enable = false;
  };

  # systemd.user.services.lkbd = {
  #   enable = true;
  #   after = [ "network.target" ];
  #   wantedBy = [ "default.target" ];
  #   description = "lkbd";
  #   serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${inputs.lkb.packages."${pkgs.system}".lkb}/bin/lkbd";
  #       Restart = "always";
  #   };
  # };

  # programs.fish.loginShellInit = ''
  #   set TTY1 (tty)
  #   [ "$TTY1" = "/dev/tty1" ] && exec niri
  # '';
  
  services.xserver = {
    enable = false;
    displayManager.gdm.enable = enable_gdm;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
