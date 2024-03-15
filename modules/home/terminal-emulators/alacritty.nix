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

    font = {
      family = mkOption {
        type = types.str;
        default = "Hack Nerd Font";
      };
      size = mkOption {
        type = types.int;
        default = 12;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          inherit (cfg) opacity;
          blur = true;
        };

        font = {
          inherit (cfg.font) size;
        } // builtins.mapAttrs (name: value: {
          inherit (cfg.font) family;
          style = value;
        }) {
          normal = "Regular";
          bold = "Bold";
          italic = "Italic";
          bold_italic = "Bold_Italic";
        };

        colors = with config.colorScheme.palette; {
          primary = {
            foreground = "#${base05}";
            background = "#${base00}";
            dim_foreground = "#${base04}";
            bright_foreground = "#${base05}";
          };
          cursor = {
            text = "#${base05}";
            cursor = "#${base07}";
          };
          vi_mode_cursor = {
            text = "#${base05}";
            cursor = "#${base07}";
          };
          search.matches = {
            foreground = "#${base04}";
            background = "#${base02}";
          };
          search.focused_match = {
            foreground = "#${base00}";
            background = "#${base0A}";
          };
          hints.start = {
            foreground = "#${base04}";
            background = "#${base01}";
          };
          hints.end = {
            foreground = "#${base03}";
            background = "#${base01}";
          };
          line_indicator = {
            foreground = "None";
            background = "None";
          };
          footer_bar = {
            foreground = "#${base05}";
            background = "#${base01}";
          };
          selection = {
            text = "#${base05}";
            background = "#${base0F}";
          };
          normal = {
            black = "#${base02}";
            red = "#${base08}";
            green = "#${base0C}";
            yellow = "#${base09}";
            blue = "#${base0B}";
            magenta = "#${base0D}";
            cyan = "#${base0A}";
            white = "#${base05}";
          };
          bright = {
            black = "#${base03}";
            red = "#${base08}";
            green = "#${base0C}";
            yellow = "#${base09}";
            blue = "#${base0B}";
            magenta = "#${base0D}";
            cyan = "#${base0A}";
            white = "#${base05}";
          };
          dim = {
            black = "#${base03}";
            red = "#${base08}";
            green = "#${base0C}";
            yellow = "#${base09}";
            blue = "#${base0B}";
            magenta = "#${base0D}";
            cyan = "#${base0A}";
            white = "#${base05}";
          };
        };
      };
    };
  };
}
