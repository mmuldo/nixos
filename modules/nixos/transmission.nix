{ lib, pkgs, config, user, ... }:

with lib;
let
  cfg = config.transmission;
in
{
  options.transmission = {
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

      settings = {
        blocklist-enabled = cfg.blocklist.enable;
        blocklist-url = cfg.blocklist.url;
      };
    };

    users.users.${user.name}.extraGroups = [ "transmission" ];
  };
}
