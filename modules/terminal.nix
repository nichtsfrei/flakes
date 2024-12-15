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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware.gpgSmartcards.enable = true;
}
