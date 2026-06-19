{ pkgs, inputs, enable_gdm ? true, ... }:
{

  environment.systemPackages = with pkgs; [
    xdg-utils
    pavucontrol
    pamixer
    # librewolf - unmaintained, currently via distrobox
    playerctl
    xwayland-satellite
    signal-desktop
    element-desktop
    brightnessctl
    shortwave
    foot
    fuzzel
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-utilities.enable = true;
  services.gnome.gnome-remote-desktop.enable = false;

  programs.niri = {
    enable = true;
  };
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    pd.enable = true;
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

# services.greetd = {
#   enable = true;
#   settings = {
#     default_session = {
#       command = "${config.programs.niri.package}/bin/niri-session";
#       user = "philipp";
#     };
#   };
# };

# NixOS otherwise injects a stripped PATH via Environment= on the niri.service
# unit which shadows the imported user-manager PATH. Disabling the default
# lets niri inherit the full PATH set up by niri-session.
systemd.user.services.niri.enableDefaultPath = false;

}
