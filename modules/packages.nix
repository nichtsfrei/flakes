{ pkgs, ...}:

{
    home.packages = (with pkgs; [
        alacritty
        brightnessctl
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
    ]);
}
