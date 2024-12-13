{ pkgs, ... }:
{
  xdg.configFile."autostart".source = ./config;
}
