{ lib, config, ... }:

with lib;
let
  cfg = config.wg-vpn.client;
in
{
  options.wg-vpn.client = {
    enable = mkEnableOption "wireguard vpn client";

    interface = {
      name = mkOption {
        type = types.str;
        default = "wg0";
      };

      ipv4.address = mkOption {
        type = types.str;
        default = "10.0.0.2";
      };
    };

    privateKeyFile = mkOption {
      type = types.path;
    };

    server = {
      ipv4 = {
        privateAddress = mkOption {
          type = types.str;
          default = "10.0.0.1";
        };
        publicAddress = mkOption {
          type = types.str;
        };
      };

      listenPort = mkOption {
        type = types.port;
        default = 51820;
      };

      publicKey = mkOption {
        type = types.str;
      };
    };

    allowedIPs = mkOption {
      type = with types; listOf str;
      default = [ "0.0.0.0/0" ];
    };

    persistentKeepalive = mkOption {
      type = types.int;
      default = 25;
    };
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces = {
      ${cfg.interface.name} = {
        address = [ cfg.interface.ipv4.address ];
        dns = [ cfg.server.ipv4.privateAddress ];
        inherit (cfg) privateKeyFile;

        peers = [
          {
            inherit (cfg.server) publicKey;
            inherit (cfg) allowedIPs persistentKeepalive;
            endpoint = "${cfg.server.ipv4.publicAddress}:${toString cfg.server.listenPort}";
          }
        ];
      };
    };
  };
}
#{
#  networking = {
#    firewall.enable = false;
#    # firewall = {
#    #   allowedTCPPorts = [ 22 80 443 53 49640 ];
#    #   allowedUDPPorts = [ 53 80 443 51820 49640 ];
#    # };
#
#    wg-quick.interfaces = {
#      wg0 = {
#        address = [ "10.0.0.3/32" ];
#        dns = [ "10.0.0.1" ];
#        listenPort = 51820;
#        privateKeyFile = "/root/wireguard-keys/private.key";
#        peers = [
#          {
#            inherit (server) publicKey;
#            allowedIPs = [ "0.0.0.0/0" "::/0" ];
#            endpoint = "${server.ip}:${server.port}";
#            persistentKeepalive = 25;
#          }
#        ];
#      };
#    };
#  };
#}
