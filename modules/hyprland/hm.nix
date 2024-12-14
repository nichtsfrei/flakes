{ inputs, pkgs, ... }:
{
   xdg.configFile."hypr".source = ./config;
   xdg.dataHome."icons".source = ./icons;
  # TODO move to pkgs and hypr default
}
