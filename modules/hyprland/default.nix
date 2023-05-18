{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;

  programs.fish.loginShellInit = ''
    set TTY1 (tty)
    [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
  '';
}
