{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    penvim.url = "github:nichtsfrei/penvim";
  };

  outputs = {
    nixpkgs,
    penvim,
    self,
    ...
  } @ inputs: {
    nixosConfigurations = import ./modules/default.nix {
      inherit self nixpkgs inputs;
    };
  };
}
