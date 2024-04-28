{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.daw;
in
{
  options.daw = {
    enable = mkEnableOption "music production software";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ardour
      vital
    ];
  };
}
