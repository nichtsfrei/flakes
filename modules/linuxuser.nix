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
    sudo -u ${username} mkdir -p /home/${username}/src/nichtsfrei
    sudo -u ${username} git clone git@github.com:nichtsfrei/dotfiles.git /home/${username}/src/nichtsfrei/dotfiles || true
    sudo -u ${username} sh /home/${username}/src/nichtsfrei/dotfiles/install.sh
    '';
}
