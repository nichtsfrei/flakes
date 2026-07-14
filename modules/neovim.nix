{ pkgs, ... }:

let
  neovimConfig = {
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
  };
in
[
  (pkgs.neovim.override neovimConfig)

  # lsps that I need outside of nix develop projects
  pkgs.nixd
  pkgs.nixfmt
  pkgs.lua-language-server
  pkgs.luarocks
]
