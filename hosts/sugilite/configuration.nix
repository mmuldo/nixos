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
  ];

  #wg-vpn.client = {
  #  enable = true;
  #  interface.ipv4.address = "10.0.0.3";
  #  privateKeyFile = "/root/wireguard-keys/private.key";
  #  server = {
  #    publicKey = "ViM1WXRmG4HL4eFbGw6s1EqiND7KXtLiE1h4kosMdw0=";
  #    ipv4.publicAddress = "172.234.95.55";
  #  };
  #};

  normal-users.${user.name} = {
    ssh.authorizedKeys = user.ssh.authorizedKeys;
  };

  #editors.neovim.enable = true;

  #media.enable = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

