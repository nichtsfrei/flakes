{ pkgs, ... }:

let
  footConfig = pkgs.writeText "foot.ini" (builtins.readFile ./foot.ini);
  footWithConfig = pkgs.writeShellScriptBin "foot" ''
    exec ${pkgs.foot}/bin/foot -c "${footConfig}" "$@"
  '';
  footWithDesktopEntry = pkgs.runCommandLocal "foot-with-desktop-entry" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mkdir -p $out/bin
    cp ${footWithConfig}/bin/foot $out/bin/
    chmod +x $out/bin/foot
    cp ${pkgs.foot}/share/icons/hicolor/scalable/apps/foot.svg $out/share/icons/hicolor/scalable/apps/
    cat > $out/share/applications/foot.desktop <<EOF
    [Desktop Entry]
    Name=foot
    Exec=$out/bin/foot
    Type=Application
    Terminal=false
    Icon=foot
    Categories=System;TerminalEmulator;
    EOF
  '';
in
[
  footWithDesktopEntry
]
