{ lib, config, inputs, ... }:

with lib;
let
  cfg = config.bars.waybar;

  moduleStyle = { target, borderColor, backgroundColor }: ''
    ${target} {
        background: linear-gradient(
            55deg,
            ${borderColor},
            ${backgroundColor} 33%,
            ${backgroundColor} 67%,
            ${borderColor}
        );
        border: 3px solid ${borderColor};
    }
  '';

  moduleStyles = [
    {
      target = "#clock";
      borderColor = "@base08";
      backgroundColor = "@base09";
    }
    
    {
      target = "#cpu";
      borderColor = "@base0D";
      backgroundColor = "@base0A";
    }
    
    {
      target = "#disk";
      borderColor = "@base02";
      backgroundColor = "@base0B";
    }
    
    {
      target = "#memory";
      borderColor = "@base09";
      backgroundColor = "@base08";
    }
    
    {
      target = "#network";
      borderColor = "@base0D";
      backgroundColor = "@base05";
    }
    
    {
      target = "#window";
      borderColor = "@base08";
      backgroundColor = "@base0A";
    }
    
    {
      target = "#wireplumber";
      borderColor = "@base0B";
      backgroundColor = "@base0C";
    }
    
    {
      target = "#workspaces";
      borderColor = "@base02";
      backgroundColor = "@base03";
    }
    
    {
      target = "#temperature";
      borderColor = "@base0B";
      backgroundColor = "@base0C";
    }
    
    {
      target = "#temperature.critical";
      borderColor = "@base08";
      backgroundColor = "@base09";
    }

    {
      target = "#tray";
      borderColor = "@base03";
      backgroundColor = "@base0D";
    }
  ];
in
{
  options.bars.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings.mainBar = {
        reload_style_on_change = true;

        margin = "20px 20px 0 20px";

        layer = "top";

        modules-left = [
          "hyprland/workspaces"
          "tray"
          "disk"
          "memory"
          "cpu"
          "temperature"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "network"
          "wireplumber"
          "clock"
        ];

        clock = {
          format = "  {:%a, %b %d, %Y %I:%M %p}";
        };

        cpu = {
          interval = 5;
          format = " {usage}%";
        };

        disk = {
          interval = 30;
          format = " {percentage_used}%";
        };

        memory = {
          interval = 5;
          format = "󰧑 {percentage}%";
        };

        network = {
          interval = 5;
          format-disconnected = "󰤮";
          format-ethernet = "󱎔  {bandwidthUpBits}  {bandwidthDownBits}";
          format-wifi = "{icon}  {bandwidthUpBits}  {bandwidthDownBits}";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰸈 {volume}%";
          format-icons = ["󰕿" "󰖀" "󰕾"];
        };

        temperature = {
          thermal-zone = 1;
          interval = 5;
          critical-threshold = 50;
          format = "󰔏 {temperatureC}C";
          format-critical = "󰸁 {temperatureC}C";
        };

        "hyprland/windows" = {
          format = "󱄅 {app_id}";
        };

        "hyprland/workspaces" = {
          format = "{icon} {windows}";
          format-window-separator = " ";
          window-rewrite-default = "󰲋";
          window-rewrite = {
            alacritty = "";
            brave = "";
            "title<.*nvim.*>" = "";
            spotify = "";
          };
        };
      };

      style = mkForce ''
        * {
            font-family: "${config.stylix.fonts.monospace.name}";
            font-weight: bold;
            border-radius: 10px;
            padding: 0 5px;
        }
        
        window#waybar {
            background: @background;
            border-radius: 10px;
            border: 2px solid @base0F;
        }
        
        .modules-left > * > *,
        .modules-center > * > *,
        .modules-right > * > * {
            margin: 10px;
            padding: 0 10px;
            color: @base00;
        }
        
        ${builtins.concatStringsSep "\n\n" (map moduleStyle moduleStyles)}
        
        #workspaces button {
            border-radius: 10px;
            color: @base06;
        }
        
        #workspaces button.active {
            background: @base07;
            color: @base02;
            border: 3px solid @base02;
        }
      '';
    };
  };
}
