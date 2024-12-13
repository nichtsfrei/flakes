{ pkgs, ... }:
{
  xdg.configFile."fontconfig".source = ./config;
}
