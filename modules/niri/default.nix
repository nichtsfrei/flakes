{ lib, pkgs, user, ... }:

let
  footPackages = import ../foot.nix { inherit pkgs; };
  desktopPackages = import ../desktop.nix { inherit pkgs; };
  seedConfig =
    fileName: sourcePath:
    let
      configSource = pkgs.writeText fileName (builtins.readFile sourcePath);
    in
    ''
      home="/home/${user.handle}"
      targetDir="$(dirname "/home/${user.handle}/.config/${fileName}")"
      target="$targetDir/$(basename "/home/${user.handle}/.config/${fileName}")"

      if [ ! -e "$target" ]; then
        mkdir -p "$targetDir"
        cp "${configSource}" "$target"
        chown ${user.handle}:users "$targetDir" "$target"
        chmod 755 "$targetDir"
        chmod 644 "$target"
        echo "seeded $target"
      else
        echo "$target exists, leaving it alone"
      fi
    '';
in
{

  environment.systemPackages =
    with pkgs;
    [
      brightnessctl
      fuzzel
    ]
    ++ desktopPackages
    ++ footPackages;

  services.udisks2.enable = true;

  programs.niri = {
    enable = true;
  };

  # Use greetd with autologin for niri
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = user.handle;
      };
    };
  };

  systemd.user.services.niri.enableDefaultPath = false;
  services.power-profiles-daemon.enable = true;


  system.activationScripts =
    lib.mapAttrs
      (name: _: seedConfig name (./. + "/${name}"))
      {
        "niri/config.kdl" = { };
        "fuzzel/fuzzel.ini" = { };
      };

}
