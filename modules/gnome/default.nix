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
    keepassxc
  ];

  environment.gnome.excludePackages = (with pkgs; [
    atomix # puzzle game
    epiphany # web browser
    geary # email reader
    gedit # text editor
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);

  services.desktopManager.gnome.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.gnome-remote-desktop.enable = false;
  services.flatpak.enable = true;
  services.displayManager.gdm.enable = true;

  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
