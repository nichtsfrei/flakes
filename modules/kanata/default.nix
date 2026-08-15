{
  config,
  lib,
  pkgs,
  devices,
  ...
}:

let
  kanataConfig = (builtins.readFile ./default.kbd);
in {
  hardware.uinput.enable = true;

  services.kanata = {
    enable = true;
    package = pkgs.kanata;
    keyboards = {
      default = {
        devices = devices;
        config = kanataConfig;
        extraDefCfg = ''
        process-unmapped-keys yes
        concurrent-tap-hold yes
        '';

      };
    };
  };
}
