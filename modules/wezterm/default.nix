{ pkgs, ... }:
{
  xdg.configFile."wezterm".source = ./config;
  home.packages = with pkgs; [ wezterm ];
}
