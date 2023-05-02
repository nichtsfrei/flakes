{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, self, ... }@inputs:
  {
      nixosConfigurations = (import ./modules/default.nix {
        inherit self nixpkgs inputs;
      });
   };
}
