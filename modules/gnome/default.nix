{ pkgs, ... }:

let
  footPackages = import ../foot.nix { inherit pkgs; };
in
{

  environment.systemPackages = with pkgs; [
    xdg-utils
    pavucontrol
    xdg-desktop-portal-gnome
    pamixer
    librewolf
    chromium
    playerctl
    xwayland-satellite
    signal-desktop
    element-desktop
    shortwave
    wl-clipboard
    vlc
    keepassxc
  ] ++ footPackages;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-terminal # OSC52 issues
    atomix # puzzle game
    epiphany # web browser
    geary # email reader
    gedit # text editor
    gnome-music
    gnome-photos
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
  services.flatpak.enable = false;
  services.displayManager.gdm.enable = true;

  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
