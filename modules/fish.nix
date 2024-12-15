{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ any-nix-shell ];
  programs.fish = {
    promptInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      nixclean =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system; sudo nix-collect-garbage --delete-older-than 5d; nix store optimise"
        else
          "sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system; sudo nix-collect-garbage --delete-older-than 5d; nix store optimise; sudo nixos-rebuild boot";
      nixswitch =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "darwin-rebuild switch --impure --flake ~/src/nichtsfrei/flakes/.#"
        else
          "sudo nixos-rebuild switch --flake ~/src/nichtsfrei/flakes/.#";
      nixup = "pushd ~/src/nichtsfrei/flakes; nix flake update; nixswitch; popd";
    };
    shellInit = ''
      set EDITOR hx
    '';
    enable = true;
  };
}
