{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
     any-nix-shell
  ];
  programs.fish = {
    promptInit = ''
        any-nix-shell fish --info-right | source
    '';
    loginShellInit = ''
      set TTY1 (tty)
      [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
    '';
    shellInit = ''
      set PATH $PATH ~/.cargo/bin
      set PATH $PATH ~/.local/bin
    '';
    enable = true;
  };
}
