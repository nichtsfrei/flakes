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
   debug = true;
   mode = "challenge-response";
   id = [ "15441492" ];
};

services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

}
