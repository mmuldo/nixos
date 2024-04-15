{ pkgs, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  environment.systemPackages = with pkgs; [
    gcc
    yt-dlp
  ];

  wg-vpn = {
    enable = true;

    client = {
      enable = true;
      server = {
        publicKey = "fVm8OYWhwqFRr9QCQO4W/TDxUaEBCL6brXfnTXqhODw=";
        ipv4.publicAddress = "45.79.82.159";
      };
    };
  };

  normal-users.${user.name} = {
    ssh.authorizedKeys = user.ssh.authorizedKeys;
  };

  users.users.root.openssh.authorizedKeys.keys = user.ssh.authorizedKeys;

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  media.enable = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

