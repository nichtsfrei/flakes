{
  pkgs,
  inputs,
  lib,
  config,
  user,
  hmextraimports,
  ...
}:
let
  username = user.handle;
  inherit (user) name;
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
    ];
  };
}
