{ lib, config, ... }:

with lib;
let
  cfg = config.pipewire;
in
{
  options.pipewire = {
    enable = mkEnableOption "pipewire audio backend";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
