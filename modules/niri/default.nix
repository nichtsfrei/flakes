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
    niri
    fuzzel
    swayidle
    swaylock
    waybar
    pamixer
    firefox
  ];
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = { };

  programs.fish.loginShellInit = ''
    set TTY1 (tty)
    [ "$TTY1" = "/dev/tty1" ] && exec niri
  '';

  
  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };


}
