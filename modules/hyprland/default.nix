{ inputs, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    fzf
    xdg-utils
    pavucontrol
    brightnessctl
    grim
    slurp
    wl-clipboard
    wf-recorder
    hyprlock
    hypridle
    hyprpaper

    firefox
  ];

  services.xserver.enable = false;
  programs.hyprland.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.loginShellInit = ''
    set TTY1 (tty)
    [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
  '';
}
