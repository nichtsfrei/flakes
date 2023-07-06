{
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings.font.normal.family = "FiraCode Nerd Font Mono";
    settings.font.size = 12;
    settings.window.option_as_alt = "Both";
  };
}
