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
      editor = hx
    EOF
    chown ${username}:users /home/${username}/.gitconfig
  '';
  system.activationScripts.copyConfig = ''
    mkdir -p /home/${username}/.config
    cp -r ${../dotfiles}/* /home/${username}/.config/
    chown -R ${username}:users /home/${username}/.config
  '';
}
