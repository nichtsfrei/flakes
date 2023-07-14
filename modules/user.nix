{
  pkgs,
  inputs,
  lib,
  config,
  user,
  hmextraimports,
  ...
}: let
  inherit (user) name;
  username = user.handle;
  inherit (user) email;
  packages = with pkgs; [
    ripgrep
    fd
    curl
    less
    pass
    clang-tools
    rustup
    nil
    penvim
    gh
    jq
  ];
in {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users.${username} = {
      home.username = username;
      #home.homeDirectory = "/home/${username}";
      home.stateVersion = "22.11";
      home.packages = packages;
      #       programs.home-manager.enable = true;
      programs.git.enable = true;
      programs.git.userName = name;
      programs.git.userEmail = email;
      imports =
        [
          ./alacritty.nix
          ./tmux
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
