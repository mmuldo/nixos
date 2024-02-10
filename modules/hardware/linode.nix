{ config, lib, pkgs, modulesPath, ... }:

with lib;
let
  cfg = config.hardware.linode;
in
{
  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];

  options.hardware.linode = {
    enable = mkEnableOption "linode server base config";
  };

  config = mkIf cfg.enable {
    # Set up filesystems according to Linode preference:
    fileSystems."/" = {
      device = "/dev/sda";
      fsType = "ext4";
      autoResize = true;
    };

    swapDevices = [{device = "/dev/sdb";}];

    # Enable LISH and Linode booting w/ GRUB
    boot = {
      # Add kernel modules detected by nixos-generate-config:
      initrd.availableKernelModules = [
        "virtio_pci"
        "virtio_scsi"
        "ahci"
        "sd_mod"
      ];

      growPartition = true;

      # Set up LISH serial connection:
      kernelParams = ["console=ttyS0,19200n8"];

      loader = {
        # Increase timeout to allow LISH connection:
        timeout = lib.mkForce 10;

        grub = {
          enable = true;
          forceInstall = true;
          device = "nodev";
          fsIdentifier = "label";

          # Allow serial connection for GRUB to be able to use LISH:
          extraConfig = ''
            serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
            terminal_input serial;
            terminal_output serial
          '';

          # Link /boot/grub2 to /boot/grub:
          extraInstallCommands = ''
            ${pkgs.coreutils}/bin/ln -fs /boot/grub /boot/grub2
          '';

          # Remove GRUB splash image:
          splashImage = null;
        };
      };
    };

    # Hardware option detected by nixos-generate-config:
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    environment.systemPackages = with pkgs; [
      inetutils
      mtr
      sysstat
      linode-cli
    ];

    networking = {
      enableIPv6 = true;
      tempAddresses = "disabled";
      useDHCP = true;
      usePredictableInterfaceNames = false;
      interfaces.eth0 = {
        tempAddress = "disabled";
        useDHCP = true;
      };
    };

    services.qemuGuest.enable = true;
  };
}
