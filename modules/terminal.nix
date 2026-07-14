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
    # editor
    (neovim.override {
      configure = {
        customRC = ''
          luafile ${./nvim.lua}
        '';
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [
            nvim-lspconfig
            nvim-treesitter.withAllGrammars
            snacks-nvim
            oxocarbon-nvim
          ];
        };

      };
    })

    # lsps that I need outside of nix develop projects
    nixd
    nixfmt
    lua-language-server
    luarocks
    #editor-end
    man-pages
    man-pages-posix
    btop
    gcc
  ];
  documentation.dev.enable = true;
  documentation.man.cache.enable = true;

  hardware.gpgSmartcards.enable = true;
}
