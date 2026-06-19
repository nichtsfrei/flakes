{
  description = "nichtsfrei's nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
    nixos-hardware = {
#      url =  "github:NixOS/nixos-hardware/master";
      url =  "github:NixOS/nixos-hardware/master";
    };
    # nix-amd-ai.url = "github:noamsto/nix-amd-ai";
    llm-agents.url = "github:numtide/llm-agents.nix";
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
      ];
      gnome = laptop ++ [
        ./modules/gnome
      ];
      kde = laptop ++ [
        ./modules/kde
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

        denkspatz =
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
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
              ./denkspatz.nix
            ] ++ gnome;
          };
        manaspatz =
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
              ./manaspatz.nix
              ./modules/steam.nix
              ./modules/llm.nix
            ] ++ gnome;
          };

        legionspatz =
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
              ./legionspatz.nix
            ] ++ gnome;
          };


        tischspatz =
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
              ./tischspatz.nix
              ./modules/steam.nix
            ] ++ gnome;
          };
      };
    };
}
