{ lib, config, ... }:
with lib;
let
  cfg = config.bars.waybar;
in
{
  options.bars.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings.mainBar = {
        layer = "top";
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "clock"
        ];
      };

      style = ./style.css;
    };
  };
}
