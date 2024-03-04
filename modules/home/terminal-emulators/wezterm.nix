{ lib, config, ... }:

with lib;
let
  cfg = config.terminal-emulators.wezterm;
in
{
  options.terminal-emulators.wezterm = {
    enable = mkEnableOption "wezterm";

    backgroundImagePath = mkOption {
      type = types.str;
      default = "";
    };

    colorScheme = mkOption {
      type = types.str;
    };

    font = mkOption {
      type = types.str;
      default = "Hack Nerd Font";
    };
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
    
      extraConfig = ''
        local wezterm = require 'wezterm'
        local config = wezterm.config_builder()
        local scheme = wezterm.color.get_builtin_schemes()['${cfg.colorScheme}']

        config.enable_wayland = true

        config.color_scheme = '${cfg.colorScheme}'
        config.font = wezterm.font '${cfg.font}'

        config.xcursor_theme = 'Adwaita'
        config.xcursor_size = 24

        config.window_background_image = '${cfg.backgroundImagePath}'
        config.window_background_image_hsb = {
          brightness = 0.2,
          hue = 1.0,
          saturation = 1.0,
        }

        config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
        config.window_frame = {
          font = wezterm.font '${cfg.font}',

          active_titlebar_bg = scheme.background,
          inactive_titlebar_bg = scheme.background,
        }

        config.colors = {
          tab_bar = {
            background = scheme.background,
            new_tab = { bg_color = scheme.ansi[1], fg_color = scheme.foreground },
            inactive_tab = { bg_color = scheme.ansi[1], fg_color = scheme.foreground },
            active_tab = { bg_color = scheme.ansi[5], fg_color = scheme.foreground },
          }
        }

        return config
      '';
    };
  };
}
