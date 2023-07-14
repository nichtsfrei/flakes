{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings.font.normal.family = "FiraCode Nerd Font Mono";
    settings.font.size = 14;
    settings.window.option_as_alt = "Both";
  };
}
