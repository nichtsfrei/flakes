{
  pkgs,
  inputs,
  user,
  hmextraimports,
  ...
}: let
  inherit (user) name;
  username = user.handle;
  inherit (user) email;
  packages = with pkgs; [
     gh
  ];
in {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users.${username} = {
      home.username = username;
      home.stateVersion = "22.11";
      home.packages = packages;
      programs.git.enable = true;
      programs.git.userName = name;
      programs.git.userEmail = email;
      imports = [
        ]
        ++ hmextraimports;
    };
  };

  users.users.${username} = {
    #    isNormalUser = true;
    #    description = name;
    #    extraGroups = [ "wheel" "audio" "video" "networkmanager"  ];
    shell = pkgs.fish;
  };
  nix.settings.allowed-users = ["${username}"];
}
