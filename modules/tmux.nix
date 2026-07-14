{ pkgs, ... }:

let
  tmuxConfig = pkgs.writeText "tmux.conf" (builtins.readFile ./tmux.conf);
  tmuxWithConfig = pkgs.writeShellScriptBin "tmux" ''
    exec ${pkgs.tmux}/bin/tmux -f "${tmuxConfig}" "$@"
  '';
in
[
  tmuxWithConfig
]
