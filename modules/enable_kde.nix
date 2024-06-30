{
  inputs,
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs; [
      fzf
      xdg-utils
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

  
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}
