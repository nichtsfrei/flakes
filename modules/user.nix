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
    python3
    gcc-arm-embedded
    dfu-util
    qmk
    gnumake
    clang
    ripgrep
    file
    fd
    curl
    less
    pass
    clang-tools
    rustup
    nodejs
    nil
    neovim
    gh
    jq
    wezterm
    stylua
    lua-language-server
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
