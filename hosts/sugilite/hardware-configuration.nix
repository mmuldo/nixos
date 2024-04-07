# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  environment.systemPackages = with pkgs; [
    mergerfs
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/94571110-4c30-419e-8790-2f1bbe187c53";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BC48-C5A8";
      fsType = "vfat";
    };

  fileSystems."/mnt/media1" = {
    device = "/dev/disk/by-label/media1";
    fsType = "ext4";
  };

  fileSystems."/mnt/media2" = {
    device = "/dev/disk/by-label/media2";
    fsType = "ext4";
  };

  fileSystems."/media" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/media*";
    options = ["cache.files=partial" "dropcacheonclose=true" "category.create=mfs"];
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d8fa430d-ccfc-43cf-8478-10604f7377a8"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
