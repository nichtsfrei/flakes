{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."hypr".source = ./config;
  # TODO move to pkgs and hypr default
}
