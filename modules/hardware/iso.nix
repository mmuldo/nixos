{ inputs, config, lib, pkgs, system, user, ... }:

with lib;
let
  cfg = config.hardware.iso;
in
{
  imports = [
    inputs.nixos-generators.nixosModules.all-formats
  ];
  
  options.hardware.iso = {
    enable = mkEnableOption "nixos iso generation";
  };

  config = mkIf cfg.enable {
    nixpkgs.hostPlatform = system;

    environment.systemPackages = with pkgs; [
      vim
      wget
    ];

    networking.firewall = {
      allowedTCPPorts = [ 22 ];
    };

    users.users.root.openssh.authorizedKeys.keys = user.ssh.authorizedKeys;

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
