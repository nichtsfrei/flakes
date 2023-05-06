{ inputs, nixpkgs, self, ... }:

let
  pkgs = import nixpkgs {
    config.allowUnfree = true;
  };
  lib = nixpkgs.lib;
in
{
  denkspatz = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs; };
    # TODO move all but denkspatz to an own module
    modules =
      [ (import ./bootloader.nix) ] ++
      [ (import ./misc.nix) ] ++
      [ (import ./fish.nix) ] ++
      [ (import ./fonts.nix) ] ++
      [ (import ./philipp.nix ) ] ++
      [ (import ./../denkspatz.nix) ];
  };
}
