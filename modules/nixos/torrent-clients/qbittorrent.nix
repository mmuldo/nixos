{ lib, pkgs, config, user, ... }:

with lib;
let
  cfg = config.torrent-clients.qbittorrent;
in
{
  options.torrent-clients.qbittorrent = {
    enable = mkEnableOption "qBittorrent torrent client";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = "directory where qBittorrent stores its data files";
    };

    user = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = "user account under which qBittorrent runs";
    };

    group = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = "group under which qBittorrent runs";
    };

    webUiPort = mkOption {
      type = types.port;
      default = 8080;
    };

    vpnService = mkOption {
      type = types.str;
      default = "wg-quick-wg0.service";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qbittorrent-nox;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.webUiPort ];

    systemd = {
      tmpfiles.rules = [
        "d '${cfg.dataDir}' 0770 ${cfg.user} ${cfg.group}"
      ];

      services.qbittorrent = {
        description = "qBittorrent service";
        documentation = [ "man:qbittorrent-nox(1)" ];
        after = [
          "network.target"
          "${cfg.vpnService}"
        ];
        requires = [ "${cfg.vpnService}" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;

          ExecStart = "${cfg.package}/bin/qbittorrent-nox";

        };

        environment = {
          QBT_PROFILE = cfg.dataDir;
          QBT_WEBUI_PORT = toString cfg.webUiPort;
        };
      };
    };

    users = {
      users = mkMerge [
        {
          ${user.name}.extraGroups = [ cfg.group ];
        }

        (mkIf (cfg.user == "qbittorrent") {
          qbittorrent = {
            isSystemUser = true;
            group = cfg.group;
          };
        })
      ];

      groups = mkIf (cfg.group == "qbittorrent") {
        qbittorrent = {};
      };
    };
  };
}
