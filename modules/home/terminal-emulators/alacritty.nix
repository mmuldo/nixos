{ lib, config, ... }:

with lib;
let
  cfg = config.terminal-emulators.alacritty;
in
{
  options.terminal-emulators.alacritty = {
    enable = mkEnableOption "alacritty";

    opacity = mkOption {
      type = types.float;
      default = 0.75;
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          opacity = mkForce cfg.opacity;
          blur = mkForce true;
        };
      };
    };
  };
}
