{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    fzf
    jq
    ripgrep
    file
    fd
    less
    pass
    distrobox
    appimage-run
    tmux
    helix
    man-pages
    man-pages-posix
    htop
  ];
  documentation.dev.enable = true;
  documentation.man.generateCaches = true;

  hardware.gpgSmartcards.enable = true;
}
