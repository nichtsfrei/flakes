{
  inputs,
  pkgs,
  ...
}: {
  imports = [(import ./variables.nix)];
  xdg.configFile."hypr".source = ./config;
  home.packages = with pkgs;
    [
      wofi
      xdg-utils
      pavucontrol
      brightnessctl
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
