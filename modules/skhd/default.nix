{pkgs, ...}: {
  xdg.configFile."skhd".source = ./config;

  # for some reasons skhd needs the configuration in root instead of config
  # dir on login
  home.file.".skhdrc".source = ./config/skhdrc;
}
