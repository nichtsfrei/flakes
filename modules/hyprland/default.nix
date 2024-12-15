{ inputs, pkgs, ... }:
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
    hyprlock
    hypridle
    hyprpaper

    wofi
    waybar
    pamixer

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

  system.activationScripts.hyprcursors = ''
    mkdir -p /usr/share/icons
    cp -r ${./icons}/* /usr/share/icons/
  '';
}
