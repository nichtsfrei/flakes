{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    helix
    vim
    fzf
    ripgrep
    file
    fd
    less
    pass
    distrobox
    appimage-run
    tmux
  ];

  hardware.gpgSmartcards.enable = true;
}
