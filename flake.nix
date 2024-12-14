{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = import ./config.nix;
        };
      pkgs = mkPkgs "x86_64-linux";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "Shellus";
        buildInputs = [
          pkgs.nil
          pkgs.nixfmt-rfc-style
        ];
        shellHook = ''
          hx flake.nix
        '';
      };
      nixosConfigurations = {


        denkspatz =
          let
            user = {
              handle = "philipp";
              name = "Philipp Eder";
              email = "philipp.eder@posteo.net";
            };
            hmextraimports = [
              ./modules/helix
              ./modules/foot
              ./modules/waybar.nix
              ./modules/mako.nix
              ./modules/hyprland/hm.nix
              ./modules/wofi
            ];
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";

            specialArgs = {
              inherit
                self
                inputs
                user
                hmextraimports
                ;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
              ./denkspatz.nix
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
            ];
          };

        herrspatz =
          let
            user = {
              handle = "philipp";
              name = "Philipp Eder";
              email = "philipp.eder@posteo.net";
            };
            hmextraimports = [
              ./modules/helix
              ./modules/wezterm
              ./modules/waybar.nix
              ./modules/mako.nix
              ./modules/hyprland/hm.nix
              ./modules/wofi
            ];
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";

            specialArgs = {
              inherit
                self
                inputs
                user
                hmextraimports
                ;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-5
#              inputs.nixos-hardware.nixosModules.common-gpu-amd-southern-islands
              ./herrspatz.nix
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
            ];
          };
      };
    };
}
