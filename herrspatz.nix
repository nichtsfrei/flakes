{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/hardware/network/broadcom-43xx.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  networking.hostName = "herrspatz";
  hardware.enableRedistributableFirmware = lib.mkDefault true;


  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/d202eb6b-15bc-4275-a2ef-1077e36172a1";
  };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e7aaaffd-0880-4d56-9325-b96d93e5187d";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FF86-6E58";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/dd8bfe85-3ffb-4b57-8d51-2933819ec2a4"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
