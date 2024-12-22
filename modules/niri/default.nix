{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    foot
    xdg-utils
    pavucontrol
    brightnessctl
    grim
    slurp
    wl-clipboard
    wf-recorder
    xdg-desktop-portal-gnome
    # niri
    fuzzel
    swayidle
    swaylock
    waybar
    pamixer
    firefox
    squeekboard
    playerctl
  ];

  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-utilities.enable = false;
  security.pam.services.swaylock = { };
  programs.niri.enable = true;

  # programs.fish.loginShellInit = ''
  #   set TTY1 (tty)
  #   [ "$TTY1" = "/dev/tty1" ] && exec niri
  # '';

  
  services.xserver = {
    enable = false;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };


}
