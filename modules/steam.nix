{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    # app image nexusmods
    icu
    p7zip
    protontricks
    gnome.zenity
    lutris-unwrapped
  ];

}
