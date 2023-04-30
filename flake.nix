{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, self, ... }@inputs:
  {
      nixosConfigurations = (import ./modules/default.nix {
        inherit self nixpkgs inputs;
      });
   };
}
