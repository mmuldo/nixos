{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.media;
in
{
  options.media = {
    enable = mkEnableOption "media server functionality";

    user = mkOption {
      type = types.str;
      description = "owner of media files; note that this is NOT the user account under which jellyfin runs";
      default = head (attrNames config.normal-users);
    };

    group = mkOption {
      type = types.str;
      description = "group owner of media files";
      default = "users";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      qbittorrent-nox
    ];

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # TODO: script for copying qbittorrent results to media

    # TODO: qbittorrent configuration
  };
}
