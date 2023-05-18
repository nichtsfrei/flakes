{ pkgs, ...}:

{
    home.packages = (with pkgs; [
        alacritty
        pass
        firefox
        wl-clipboard
        wofi
        nodejs
        tree-sitter
        gh
        rustup
        xdg-utils
        ripgrep
        ccls
        go
        gcc
        libcap
        pavucontrol
        brightnessctl
    ]);
}
