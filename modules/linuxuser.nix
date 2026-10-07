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
      "libvirtd"
      "qemu-libvirtd"
      "plugdev"
      "dialout"
      "kvm"
      "tty"
      "scanner"
      "lp"
    ];
  };
  system.activationScripts.createGitconfig = ''
    cat <<EOF > /home/${username}/.gitconfig
    [user]
      name = ${name}
      email = ${email}
    [core]
      editor = nvim
    [init]
      defaultBranch = main
    EOF
    chown ${username}:users /home/${username}/.gitconfig
  '';
}
