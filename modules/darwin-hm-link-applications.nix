{
  config,
  pkgs,
  lib,
  ...
}: {
  # Don't change this when you change package input. Leave it alone.
  disabledModules = ["targets/darwin/linkapps.nix"]; # to prevent creation within Applications/Home\ Manager

  home.activation.aliasApplications = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
      };
      # TODO check for dead links within MacOS and delete orphans
    in
      lib.hm.dag.entryAfter ["linkGeneration"] ''
        ls -1tu ${apps}/Applications/ | while IFS= read -r entry; do
            # ohmpf
            TARGET="$HOME/Applications/$entry"
            SOURCE="${apps}/Applications/$entry"
            echo "warning: creating $entry in $TARGET; those will not be removed."
            # chmod is because of the icon
            chmod -R 7777 $TARGET && rm -rf $TARGET || echo "not removed"
            mkdir -p $TARGET/Contents
            cp $SOURCE/Contents/Info.plist $TARGET/Contents/Info.plist
            cp -r $SOURCE/Contents/Resources $TARGET/Contents/Resources
            ln -s ${apps}/bin $TARGET/Contents/MacOS
            echo "TODO figure out auto clean on broken links"
        done
      ''
  );
}
