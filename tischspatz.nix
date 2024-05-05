{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  #boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm" "kvm-amd"];
  boot.extraModulePackages = [ ];
  networking.hostName = "tischspatz"; # Define your hostname.

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d0de8d7e-f4c9-40c9-a239-2574368b603d";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-a4cf8374-2110-4b96-9c5b-22cbe2a1a275".device = "/dev/disk/by-uuid/a4cf8374-2110-4b96-9c5b-22cbe2a1a275";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/829A-D245";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp12s0f2u1u4c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  # environment.systemPackages = with pkgs; [
  #     clinfo
  #     (ollama.override { acceleration = "rocm"; })
  # ];

   programs.steam.enable = true;
   


   programs.virt-manager.enable = true;

#  programs.nix-ld.enable = true;

}
