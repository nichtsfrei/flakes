{ pkgs, inputs, enable_gdm ? true, ... }:
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
    librewolf
    # needed for characorder
    chromium
    squeekboard
    playerctl
    xwayland-satellite
    signal-desktop
    element-desktop
    shortwave
    thunderbird
    gnomeExtensions.paperwm # maybe gnome is just superior on a tablet?
    # inputs.lkb.packages."${pkgs.system}".lkb
  ];

  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-utilities.enable = false;
  services.gnome.gnome-remote-desktop.enable = false;
  services.flatpak.enable = true;

  security.pam.services.swaylock = { };
  programs.niri = {
    enable = true;
  };

  # systemd.user.services.lkbd = {
  #   enable = true;
  #   after = [ "network.target" ];
  #   wantedBy = [ "default.target" ];
  #   description = "lkbd";
  #   serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${inputs.lkb.packages."${pkgs.system}".lkb}/bin/lkbd";
  #       Restart = "always";
  #   };
  # };

  # programs.fish.loginShellInit = ''
  #   set TTY1 (tty)
  #   [ "$TTY1" = "/dev/tty1" ] && exec niri
  # '';
  
  services.xserver = {
    enable = false;
    displayManager.gdm.enable = enable_gdm;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
