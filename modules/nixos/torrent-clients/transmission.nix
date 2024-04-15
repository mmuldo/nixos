{ lib, pkgs, config, user, ... }:

with lib;
let
  cfg = config.torrent-clients.transmission;
in
{
  options.torrent-clients.transmission = {
    enable = mkEnableOption "transmission torrent client";

    blocklist = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      url = mkOption {
        type = types.str;
        default = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      };
    };
  };
  
  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;

      openPeerPorts = true;
      openRPCPort = true;

      settings = {
        bind-address-ipv4 = config.wg-vpn.client.interface.ipv4.address;
        blocklist-enabled = cfg.blocklist.enable;
        blocklist-url = cfg.blocklist.url;
        peer-port-random-on-start = true;
        peer-port-random-low = 49152;
        peer-port-random-high = 65535;
        rpc-enabled = true;
        rpc-authentication-required = false;
        rpc-whitelist-enabled = true;
        rpc-whitelist = "127.0.0.*,192.168.68.*";
      };
    };

    users.users.${user.name}.extraGroups = [ "transmission" ];
  };
}
