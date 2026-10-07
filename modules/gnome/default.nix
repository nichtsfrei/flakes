{ pkgs, ... }:

let
  footPackages = import ../foot.nix { inherit pkgs; };
  desktopPackages = import ../desktop.nix { inherit pkgs; };
in
{

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
  };
  environment.systemPackages =
    with pkgs;
    [
      xdg-desktop-portal-gnome
    ]
    ++ desktopPackages
    ++ footPackages;

  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-terminal # OSC52 issues
      atomix # puzzle game
      epiphany # web browser
      geary # email reader
      gedit # text editor
      gnome-music
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]
  );

  services.desktopManager.gnome.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-remote-desktop.enable = false;
  services.flatpak.enable = false;
  services.displayManager.gdm.enable = true;
  services.gnome.localsearch.enable = false;
  services.gnome.tinysparql.enable = false;
  services.gnome.core-apps.enable = true;
  services.gnome.core-utilities.enable = true;

  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
