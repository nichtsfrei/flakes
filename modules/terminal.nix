{ pkgs, ... }:

let
  editorPackages = import ./neovim.nix { inherit pkgs; };
  tmuxPackages = import ./tmux.nix { inherit pkgs; };
in
{
  environment.systemPackages =
    with pkgs;
    [
      curl
      git
      fzf
      jq
      ripgrep
      file
      fd
      less

      man-pages
      man-pages-posix
      btop
      gcc

      distrobox
      appimage-run
    ]
    ++ editorPackages
    ++ tmuxPackages;
  documentation.dev.enable = true;
  documentation.man.cache.enable = true;

  hardware.gpgSmartcards.enable = true;
}
