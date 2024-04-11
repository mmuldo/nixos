{ user, ... }:

{
  hardware.linode.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
  };

  wg-vpn = {
    enable = true;

    server = {
      enable = true;
      clients = [
        {
          publicKey = "MFFpTflw19GcAVebqYN0H9MBUEmonVStDz6660BK1wc=";
          ipv4.address = "10.0.0.2";
        }
      ];
    };
  };

  normal-users.${user.name} = {
    ssh.authorizedKeys = user.ssh.authorizedKeys;
  };

  users.users.root.openssh.authorizedKeys.keys = user.ssh.authorizedKeys;

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

