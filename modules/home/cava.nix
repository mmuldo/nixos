{ lib, config, ... }:

with lib;
let
  cfg = config.cava;
in
{
  options.cava = {
    enable = mkEnableOption "cava";
  };

  config = mkIf cfg.enable {
    programs.cava = {
      enable = true;
      settings = {
        output.channels = "mono";
      };
    };
  };
}
