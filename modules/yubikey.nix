{ pkgs, ... }:

{
services.udev.packages = [ pkgs.yubikey-personalization ];

programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};

security.pam.services = {
  login.u2fAuth = true;
  sudo.u2fAuth = true;
};
security.pam.yubico = {
   enable = true;
   debug = false;
   mode = "challenge-response";
   id = [ "15441492" ];
};

}
