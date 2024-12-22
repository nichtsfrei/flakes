{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    helix
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
  ];

  hardware.gpgSmartcards.enable = true;
}
