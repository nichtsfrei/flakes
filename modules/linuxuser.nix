{
  pkgs,
  inputs,
  lib,
  config,
  user,
  hmextraimports,
  ...
}: let
  username = user.handle;
  name = user.name;
in {
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = ["wheel" "audio" "video" "networkmanager"];
  };
}
