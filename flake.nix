{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    penvim.url = "github:nichtsfrei/penvim";
  };

  outputs = {
    nixpkgs,
    penvim,
    self,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib system;
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./modules/overlays.nix {
            inherit inputs nixpkgs;
          })
          overlays
          ;
        config = import ./config.nix;
      };
  in {
    #

    nixosConfigurations = {
      denkspatz = let
        user = {
          handle = "philipp";
          name = "Philipp Eder";
          email = "philipp.eder@posteo.net";
        };
        hmextraimports = [
          ./modules/packages.nix

          ./modules/waybar.nix
          ./modules/mako.nix
          ./modules/gtk
          ./modules/hyprland/hm.nix
          ./modules/tmux
          ./modules/wofi
        ];
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";

          specialArgs = {inherit self inputs user hmextraimports;};
          # TODO move all but denkspatz to an own module
          modules = [
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
            ./modules/bootloader.nix
            ./modules/misc.nix
            ./modules/bluetooth.nix
            ./modules/fish.nix
            ./modules/fonts.nix
            ./modules/hyprland
            inputs.home-manager.nixosModules.home-manager
            ./modules/user.nix
            ./modules/linuxuser.nix
            ./denkspatz.nix
          ];
        };
    };
    darwinConfigurations = {
      zygomatic = let
        user = {
          handle = "philippeder";
          name = "Philipp Eder";
          email = "philipp.eder@greenbone.net";
        };
        hmextraimports = [
          ./modules/darwin-hm-link-applications.nix
          ./modules/yabai
          ./modules/skhd
        ];
        brewextracasks = ["zoom"];
        hostName = "zygomatic";
      in
        inputs.darwin.lib.darwinSystem {
          pkgs = mkPkgs "aarch64-darwin";
          specialArgs = {
            inherit self inputs system user hmextraimports brewextracasks hostName;
          };
          modules = [
            ./modules/darwin
            ./modules/fonts.nix
            ./modules/fish.nix
            inputs.home-manager.darwinModules.home-manager
            ./modules/user.nix
          ];
        };
      angstspatz = let
        user = {
          handle = "philipp";
          name = "Philipp Eder";
          email = "philipp.eder@posteo.net";
        };
        hmextraimports = [
          ./modules/darwin-hm-link-applications.nix
          ./modules/yabai
          ./modules/skhd
        ];
        brewextracasks = ["steam" "origin"];
        hostName = "angstspatz";
      in
        inputs.darwin.lib.darwinSystem {
          pkgs = mkPkgs "aarch64-darwin";
          specialArgs = {
            inherit self inputs system user hmextraimports brewextracasks hostName;
          };
          modules = [
            ./modules/darwin
            ./modules/fonts.nix
            ./modules/fish.nix
            inputs.home-manager.darwinModules.home-manager
            ./modules/user.nix
          ];
        };
    };
  };
}
