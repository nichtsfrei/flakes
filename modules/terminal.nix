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
    neovim
    man-pages
    man-pages-posix
    htop
    gcc
  ];
  documentation.dev.enable = true;
  documentation.man.generateCaches = true;

  hardware.gpgSmartcards.enable = true;
}
