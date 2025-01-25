{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware = {
      # url =  "github:NixOS/nixos-hardware/master";
      url =  "github:nichtsfrei/nixos-hardware/master";
    };
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      mkPkgs =
        system: pkg:
        import pkg {
          inherit system;
          config = import ./config.nix;
        };
      pkgs = mkPkgs "x86_64-linux" nixpkgs;
      core = [
        ./modules/bootloader.nix
        ./modules/misc.nix
      ];
      terminal = core ++ [
        ./modules/fonts.nix
        ./modules/terminal.nix
        ./modules/fish.nix
      ];
      laptop = terminal ++ [
        ./modules/sound.nix
        ./modules/bluetooth.nix
        ./modules/linuxuser.nix
        ./modules/yubikey.nix
        ./modules/tlp.nix
      ];
      sway = laptop ++ [
        ./modules/sway
      ];
      niri = laptop ++ [
        ./modules/niri
      ];
      default_user = {
        handle = "philipp";
        name = "Philipp Eder";
        email = "philipp.eder@posteo.net";
      };
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

        spatzenschirm =
          let
            user = default_user;
          in
          nixpkgs.lib.nixosSystem {

            pkgs = mkPkgs "x86_64-linux" nixpkgs;

            specialArgs = {
              inherit
                self
                inputs
                user
                ;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.minisforum-v3
              ./spatzenschirm.nix
              ./modules/steam.nix
            ] ++ niri;
          };
        denkspatz =
          let
            user = default_user;
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux" nixpkgs;

            specialArgs = {
              inherit
                self
                inputs
                user
                ;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
              ./denkspatz.nix
            ] ++ niri;
          };

        herrspatz =
          let
            user = default_user;
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux" nixpkgs;

            specialArgs = {
              inherit
                self
                inputs
                user
                ;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-5
              #              inputs.nixos-hardware.nixosModules.common-gpu-amd-southern-islands
              ./herrspatz.nix
            ] ++ niri;
          };
      };
    };
}
