{ pkgs, inputs, ... }:

let
  name = "Philipp Eder";
  username = "philipp";
  email = "philipp.eder@posteo.net";
  packages = with pkgs;[
    fish
  ];
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
   home-manager = {
     useUserPackages = true;
     useGlobalPkgs = true;
     extraSpecialArgs = { inherit inputs; };
     users.${username} = {
       imports =
            [(import ./packages.nix)] ++
            [(import ./waybar.nix)] ++
            [(import ./mako.nix)] ++
            [(import ./hyprland/default.nix)] ++
            [(import ./wofi)] ;
       home.username = username;
       home.homeDirectory = "/home/${username}";
       home.stateVersion = "22.11";
       programs.home-manager.enable = true;
       programs.git.enable = true;
       programs.git.userName = name;
       programs.git.userEmail = email;
     };
   };

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "wheel" "audio" "video" "networkmanager"  ];
    shell = pkgs.fish;
  };
  services.getty.autologinUser = "philipp";
  nix.settings.allowed-users = [ "philipp" ];
}
