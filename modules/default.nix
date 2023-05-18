{ inputs, nixpkgs, self, ... }:

let
  lib = nixpkgs.lib;
in
{
  denkspatz = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs; };
    # TODO move all but denkspatz to an own module
    modules =
      [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480 ] ++
      [ (import ./bootloader.nix) ] ++
      [ (import ./misc.nix) ] ++
      [ (import ./bluetooth.nix) ] ++
      [ (import ./fish.nix) ] ++
      [ (import ./fonts.nix) ] ++
      [ (import ./philipp.nix ) ] ++
      [ (import ./../denkspatz.nix) ];
  };
  herrspatz = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs; };
    # TODO move all but denkspatz to an own module
    modules =
      [ inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-5 ] ++
      #[ inputs.nixos-hardware.nixosModules.common-gpu-amd-southern-islands ] ++
      #[ (import ./amd-intel-hybrid.nix) ] ++
      [ (import ./bootloader.nix) ] ++
      [ (import ./misc.nix) ] ++
      [ (import ./bluetooth.nix) ] ++
      [ (import ./fish.nix) ] ++
      [ (import ./fonts.nix) ] ++
      [ (import ./philipp.nix ) ] ++
      [ (import ./../herrspatz.nix) ];
  };
}
