{ user, ... }:

{
  hardware.linode.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
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

