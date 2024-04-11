{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.wg-vpn.server;

  clientOpts = {
    options = {

      publicKey = mkOption {
        type = types.str;
      };

      ipv4.address = mkOption {
        type = types.str;
      };

    };
  };

in
{

  options.wg-vpn.server = {
    enable = mkEnableOption "wireguard vpn server";

    interface = {
      name = mkOption {
        type = types.str;
        default = "wg0";
      };

      ipv4 = {
        address = mkOption {
          type = types.str;
          default = "10.0.0.1";
        };

        cidr = mkOption {
          type = types.str;
          default = "${cfg.interface.ipv4.address}/24";
        };
      };

      external = mkOption {
        type = types.str;
        default = "eth0";
      };
    };

    listenPort = mkOption {
      type = types.port;
      default = 51820;
    };

    firewall = {
      allowedTCPPorts = mkOption {
        type = with types; listOf port;
        default = [ 53 ];
      };

      allowedUDPPorts = mkOption {
        type = with types; listOf port;
        default = [ 53 cfg.listenPort ];
      };
    };

    clients = mkOption {
      type = with types; listOf (submodule clientOpts);
      default = [];
      description = "clients who have access to the vpn";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      nat = {
        enable = true;
        #enableIPv6 = true;
        externalInterface = cfg.interface.external;
        internalInterfaces = [ cfg.interface.name ];
      };

      inherit (cfg) firewall;

      wg-quick.interfaces = {
        ${cfg.interface.name} = {
          address = [ cfg.interface.ipv4.cidr ];
          inherit (cfg) listenPort;
          inherit (config.wg-vpn) privateKeyFile;

          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -A FORWARD -o wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
          '';
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -D FORWARD -o wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
          '';

          peers = map (client: {
            inherit (client) publicKey;
            allowedIPs = [ "${client.ipv4.address}/32" ];
          }) cfg.clients;
        };
      };
    };

    services = {
      dnsmasq = {
        enable = true;
        settings = {
          interface = cfg.interface.name;
        };
      };
    };
    };
}
