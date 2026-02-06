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
      "kvm"
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
  system.activationScripts.checkConfig = ''
    su -c "mkdir -p /home/${username}/src/nichtsfrei" ${username}
    su -c "git clone git@github.com:nichtsfrei/dotfiles.git /home/${username}/src/nichtsfrei/dotfiles || true" ${username}
    su -c "sh /home/${username}/src/nichtsfrei/dotfiles/install.sh" ${username}
    '';
}
