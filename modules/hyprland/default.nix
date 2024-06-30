{
  inputs,
  pkgs,
  ...
}: {

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

      # work stuff
      zoom-us
      # graphical stuff
      gimp
      krita
      gimp
      inkscape
      # browser
      firefox
    ];

  
  services.xserver.enable = false;
  programs.hyprland.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;

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
