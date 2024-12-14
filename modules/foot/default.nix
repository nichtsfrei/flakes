{ pkgs, ... }:
{
  xdg.configFile."foot".source = ./config;
  home.packages = with pkgs; [ foot ];
}
