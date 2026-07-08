{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ any-nix-shell ];
  programs.fish = {
    promptInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      nixclean =
          "sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system; sudo nix-collect-garbage --delete-older-than 5d; nix store optimise; sudo nixos-rebuild switch --flake ~/src/nichtsfrei/flakes/.#";
      nixswitch =
          "sudo nixos-rebuild switch --flake ~/src/nichtsfrei/flakes/.#";
      nixup = "pushd ~/src/nichtsfrei/flakes; nix flake update; nixswitch; popd";
    };
    shellInit = ''
      set EDITOR nvim
    '';
    enable = true;
  };
}
