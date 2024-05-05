{
  inputs,
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs; [
      xdg-utils
      pavucontrol
      brightnessctl
      grim
      slurp
      wl-clipboard
      wf-recorder
      # narf
      zoom-us
      # graphical stuff
      gimp
      krita
      gimp
      inkscape
      firefox
    ];

  
  services.xserver.enable = false;
  programs.hyprland.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };



  # environment.systemPackages = with pkgs; [
  #   polkit-kde-agent
  # ];
  #
  #
  # systemd = {
  #   user.services.polkit-kde-authentication-agent-1 = {
  #     description = "polkit-kde-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #         Type = "simple";
  #         ExecStart = "${pkgs.polkit-kde-agent}/lib/polkit-kde-authentication-agent-1";
  #         Restart = "on-failure";
  #         RestartSec = 1;
  #         TimeoutStopSec = 10;
  #       };
  #   };
  # };

  programs.fish.loginShellInit = ''
    set TTY1 (tty)
    [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
  '';
}
