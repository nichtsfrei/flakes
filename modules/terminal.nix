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
  ];

  hardware.gpgSmartcards.enable = true;
}
