{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "amd_iommu=off"
    "ttm.pages_limit=32505856"
    "ttm.page_pool_size=32505856"
    "amdgpu.no_system_mem_limit=1"
  ];

  # should not be needed anymore, delete afer confirmation
  # environment.sessionVariables = {
  #   HSA_OVERRIDE_GFX_VERSION = "11.5.1";
  #   HSA_ENABLE_SDMA = "0";
  # };

  fileSystems."/" = {
    device = "/dev/mapper/vogrona-lovona";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/vogrona-lovona";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/vogrona-lovona";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/mapper/vogrona-lovona";
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # AUTO SCRUB
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "manaspatz";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.firmware = [ pkgs.linux-firmware ];

  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/nvme0n1p2";
      allowDiscards = true;
      preLVM = true;
    };
  };
}
