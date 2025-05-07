{
  pkgs,
  user,
  ...
}:
let
  username = user.handle;
  inherit (user) name;
  inherit (user) email;
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "plugdev"
      "dialout"
    ];
  };
  system.activationScripts.createGitconfig = ''
    cat <<EOF > /home/${username}/.gitconfig
    [user]
      name = ${name}
      email = ${email}
    [core]
      editor = nvim
    EOF
    chown ${username}:users /home/${username}/.gitconfig
  '';
  system.activationScripts.copyConfig = ''
    mkdir -p /home/${username}/.config
    cp -r ${../core-dotfiles}/* /tmp/${username}/.config/
    chown -R ${username}:users /tmp/${username}/.config
    find /tmp/${username}/.config -type d -exec chmod 755 {} \;
    find /tmp/${username}/.config -type f -exec chmod 644 {} \;
    cp -r /tmp/${username}/.config/* /home/${username}/.config/
    rm -rf /tmp/${username}/.config
    '';
}
