{ pkgs, inputs, ... }:
{

services = {
  desktopManager.plasma6.enable = true;
  displayManager.sddm.enable = true;
  displayManager.sddm.wayland.enable = true;
};

environment.systemPackages = with pkgs; [
  kdePackages.kcalc # Calculator
  kdePackages.kcharselect # Character map
  kdePackages.kclock # Clock app
  kdePackages.kcolorchooser # Color picker
  kdePackages.ksystemlog # System log viewer
  kdePackages.sddm-kcm # SDDM configuration module
  hardinfo2 # System benchmarks and hardware info
  wayland-utils # Wayland diagnostic tools
  wl-clipboard # Wayland copy/paste support
  vlc # Media player
    signal-desktop
    element-desktop
    keepassxc
	firefox # find a better alternative
	foot
];

  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
