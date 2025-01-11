{ pkgs, inputs, ... }:
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
    fuzzel
    swayidle
    swaylock
    waybar
    pamixer
    firefox
    squeekboard
    playerctl
    xwayland-satellite
    signal-desktop
    element-desktop
    inputs.lkb.packages."${pkgs.system}".lkb
  ];

  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-utilities.enable = false;
  security.pam.services.swaylock = { };
  programs.niri = {
    enable = true;
  };

  systemd.user.services.lkbd = {
  enable = true;
  after = [ "network.target" ];
  wantedBy = [ "default.target" ];
  path = [ inputs.lkb.packages."${pkgs.system}".lkb ];
  description = "lkbd";
  serviceConfig = {
      Type = "simple";
      ExecStart = path;
      Restart = "always";
  };
};

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
