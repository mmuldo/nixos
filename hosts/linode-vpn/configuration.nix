{ config, lib, pkgs, inputs, system, user, modulesPath, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    "${toString modulesPath}/profiles/qemu-guest.nix"

    ../../modules/nixos/user.nix
    ../../modules/nixos/wg-vpn
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = system;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit user;
    };
    users.${user.name} = import ./home.nix;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ripgrep
    gcc
    inetutils
    mtr
    sysstat
    linode-cli
  ];

  users.users.root.openssh.authorizedKeys.keys = user.ssh.authorizedKeys;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      # PermitRootLogin = "no";
    };
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

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

  networking = {
    enableIPv6 = true;
    tempAddresses = "disabled";
    useDHCP = true;
    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      tempAddress = "disabled";
      useDHCP = true;
    };

    firewall = {
      allowedTCPPorts = [ 22 ];
    };
  };

  wg-vpn.server = {
    enable = true;
    privateKeyFile = "/root/wireguard-keys/private.key";
    clients = [
      {
        publicKey = "aEL1w5CRjzUXfSQB17lL6xa+CbGSR7VuOfGjSgG9JA4=";
        ipv4.address = "10.0.0.2";
      }

      {
        publicKey = "xE/QHqr/qvvsG8EWLTqkFrfSWcZhep03CFgtW3w+mVo=";
        ipv4.address = "10.0.0.3";
      }
    ];
  };
}

