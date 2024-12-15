{ pkgs, config, ... }:
{
  xdg.configFile."tmux".source = config.lib.file.mkOutOfStoreSymlink ./config;
  home.packages = with pkgs; [ tmux ];
}
