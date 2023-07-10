{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    any-nix-shell
  ];
  programs.fish = {
    promptInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      nixswitch =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "darwin-rebuild switch --impure --flake ~/src/nichtsfrei/flakes/.#"
        else "sudo nixos-rebuild switch --flake ~/src/nichtsfrei/flakes/.#";
      nixup = "pushd ~/src/nichtsfrei/flakes; nix flake update; nixswitch; popd";
    };
    shellInit = ''
      set PATH $PATH ~/.cargo/bin
      set PATH $PATH ~/.local/bin
      set EDITOR nvim
    '';
    enable = true;
  };
}
