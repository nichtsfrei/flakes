{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    fzf
    jq
    ripgrep
    file
    fd
    less
    distrobox
    appimage-run
    tmux
    neovim
    man-pages
    man-pages-posix
    btop
    gcc
  ];
  documentation.dev.enable = true;
  documentation.man.cache.enable = true;

  hardware.gpgSmartcards.enable = true;
}
