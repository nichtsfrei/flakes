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
    swayidle
    swaylock

    pamixer

    firefox
  ];
  services.gnome.gnome-keyring.enable = true;


  services.xserver.enable = false;
  programs.sway.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.loginShellInit = ''
    set TTY1 (tty)
    [ "$TTY1" = "/dev/tty1" ] && exec sway
  '';

  
  system.activationScripts.sway_confd= ''
    cp  ${./touchpad.conf} /etc/sway/config.d/
  '';
}
