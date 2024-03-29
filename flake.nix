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
  };

  outputs = {
    nixpkgs,
    self,
    ...
  } @ inputs: let
    inherit (nixpkgs) system;
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = import ./config.nix;
      };
  in {
    #

    nixosConfigurations = {
      tischspatz = let
        user = {
          handle = "philipp";
          name = "Philipp Eder";
          email = "philipp.eder@posteo.net";
        };
        hmextraimports = [
          ./modules/packages.nix
	  ./modules/nvim
	  ./modules/wezterm
        ];
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";

          specialArgs = {inherit self inputs user hmextraimports;};
          # TODO move all but tischspatz to an own module
          modules = [
            ./modules/bootloader.nix
            ./modules/misc.nix
            ./modules/sound.nix
            ./modules/bluetooth.nix
            ./modules/fish.nix
            ./modules/fonts.nix
            inputs.home-manager.nixosModules.home-manager
            ./modules/user.nix
            ./modules/linuxuser.nix
            ./tischspatz.nix
          ];
        };


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
            ./modules/sound.nix
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
      linomatic = let
        user = {
          handle = "philipp";
          name = "Philipp Eder";
          email = "philipp.eder@greenbone.net";
        };
        hmextraimports = [
        ];
      in
        nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = mkPkgs "aarch64-linux";

          specialArgs = {inherit self inputs user hmextraimports;};
          modules = [
            ./modules/bootloader.nix
            ./modules/misc.nix
            ./modules/fish.nix
            ./modules/k3s.nix
            ./modules/fonts.nix
            inputs.home-manager.nixosModules.home-manager
            ./modules/user.nix
            ./modules/linuxuser.nix
            ./linomatic.nix
          ];
        };
      simspatz = let
        user = {
          handle = "philipp";
          name = "Philipp Eder";
          email = "philipp.eder@posteo.net";
        };
        hmextraimports = [
        ];
      in
        nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = mkPkgs "aarch64-linux";

          specialArgs = {inherit self inputs user hmextraimports;};
          # TODO move all but denkspatz to an own module
          modules = [
            ./modules/bootloader.nix
            ./modules/misc.nix
            ./modules/fish.nix
            ./modules/fonts.nix
            inputs.home-manager.nixosModules.home-manager
            ./modules/user.nix
            ./modules/linuxuser.nix
            ./simspatz.nix
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
          ./modules/skhd
        ];
        brewextracasks = ["zoom" "docker"];
        brewextrapackages = ["helm"];
        hostName = "zygomatic";
      in
        inputs.darwin.lib.darwinSystem {
          pkgs = mkPkgs "aarch64-darwin";
          specialArgs = {
            inherit self inputs system user hmextraimports brewextracasks brewextrapackages hostName;
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
        ];
        brewextracasks = ["steam" "origin" "vlc" "zoom" "calibre" "element" "libreoffice" ];
        brewextrapackages = [];
        hostName = "angstspatz";
      in
        inputs.darwin.lib.darwinSystem {
          pkgs = mkPkgs "aarch64-darwin";
          specialArgs = {
            inherit self inputs system user hmextraimports brewextracasks brewextrapackages hostName;
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
