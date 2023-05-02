{ inputs, pkgs, ... }:

{
  xdg.configFile."hypr".source = ./config;
  home.packages = with pkgs;[
    brightnessctl
    swww
    hyprpicker
    swaylock-effects
    wlogout
    grim
    slurp
    wl-clipboard
    wf-recorder
    glib
    wayland
    direnv
  ];
}

