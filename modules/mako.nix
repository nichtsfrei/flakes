{ config, pkgs, ... }:

{
  services = {
    mako = {
      enable = true;
      font = "FiraCode Nerd Font 11";
      padding = "20";
      defaultTimeout = 5000;
      borderSize = 2;
      borderRadius = 6;
      backgroundColor = "#1e1e2e";
      borderColor = "#20668698";
      progressColor = "over #313244";
      textColor = "#cdd6f4";
      extraConfig = ''
        text-alignment=center
        [urgency=high]
        border-color=#B45C65
      '';
    };
  };
}
