{ pkgs, inputs, ... }:
{
  programs.steam = {
    enable = true;
  };

  
  environment.systemPackages = with pkgs; [
    protontricks
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer
  ];

}
