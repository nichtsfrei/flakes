{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    # TODO: this does not work on new installs, maybe better to move out
    lkb.url = "path:./lkb";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
    nixos-hardware = {
#      url =  "github:NixOS/nixos-hardware/master";
      url =  "github:nichtsfrei/nixos-hardware/master";
    };
  };

  outputs =
    { jovian-nixos, nixpkgs, self, ... }@inputs:
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
      gnome = laptop ++ [
        ./modules/gnome
      ];
      user = {
        handle = "philipp";
        name = "Philipp Eder";
        email = "philipp.eder@posteo.net";
      };
      enable_gdm = true;
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
          nvim flake.nix
        '';
      };
      nixosConfigurations = {

        spatzenbad =
          let
            enable_gdm = false;
          in
          nixpkgs.lib.nixosSystem {

            pkgs = mkPkgs "x86_64-linux" nixpkgs;
            specialArgs = {
              inherit
                self
                inputs
                user
                enable_gdm
                ;
            };
            modules = [
              ./spatzenbad.nix
              ./modules/steam.nix
              jovian-nixos.nixosModules.default
              {
                jovian.devices.steamdeck.enable = true;
                jovian.steam.autoStart = true;
                jovian.steam.enable = true;
                jovian.devices.steamdeck.autoUpdate = true;
                jovian.steam.user = user.handle;
                jovian.steam.desktopSession = "niri";
                
              }
            ] ++ niri;
          };
        schirmspatz =
          nixpkgs.lib.nixosSystem {

            pkgs = mkPkgs "x86_64-linux" nixpkgs;
            specialArgs = {
              inherit
                self
                inputs
                user
                enable_gdm
                ;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.minisforum-v3
              ./schirmspatz.nix
              ./modules/steam.nix
              
            ] ++ gnome;
          };
        denkspatz =
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
            ] ++ gnome;
          };

        herrspatz =
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
