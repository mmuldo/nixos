{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.menus.rofi;
in
{
  options.menus.rofi = {
    enable = mkEnableOption "rofi";

    terminal = mkOption {
      type = types.path;
      default = "${pkgs.alacritty}/bin/alacritty";
    };

    backgroundImagePath = mkOption {
      type = types.path;
      default = ../../../wallpapers/rose-pine/contourline.png;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-power-menu
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      pass.enable = true;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];

      extraConfig = {
        modi =                       "drun,filebrowser,run,ssh";
        show-icons =                 true;
        display-drun =               "apps";
        display-filebrowser =        "files";
        display-run =                "run";
        display-ssh =                "ssh";
        drun-display-format =        "{name}";
        window-format =              "{w} · {c} · {t}";
      };

      theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        # Author : Aditya Shakya (adi1090x)
        # Github : @adi1090x
        #
        # Rofi Theme File
        # Rofi Version: 1.7.3

        window = {
          transparency =                "real";
          location =                    mkLiteral "center";
          anchor =                      mkLiteral "center";
          fullscreen =                  false;
          width =                       mkLiteral "1000px";
          x-offset =                    mkLiteral "0px";
          y-offset =                    mkLiteral "0px";
          enabled =                     true;
          border =                      mkLiteral "2px solid";
          border-color =                mkForce (mkLiteral "@selected-normal-background");
          border-radius =               mkLiteral "15px";
          cursor =                      "default";
          background-color =            mkForce (mkLiteral "@background");
        };

        mainbox = {
          enabled =                     true;
          spacing =                     mkLiteral "0px";
          background-color =            mkForce (mkLiteral "transparent");
          orientation =                 mkLiteral "horizontal";
          children =                    [ "imagebox" "listbox" ];
        };

        imagebox = {
          padding =                     mkLiteral "20px";
          background-color =            mkForce (mkLiteral "transparent");
          background-image =            mkLiteral ''url("${cfg.backgroundImagePath}", height)'';
          orientation =                 mkLiteral "vertical";
          children =                    [ "inputbar" "dummy" "mode-switcher" ];
        };

        listbox = {
          spacing =                     mkLiteral "20px";
          padding =                     mkLiteral "20px";
          background-color =            mkForce (mkLiteral "transparent");
          orientation =                 mkLiteral "vertical";
          children =                    [ "message" "listview" ];
        };

        dummy = {
          background-color =            mkForce (mkLiteral "transparent");
        };

        inputbar = {
          enabled =                     true;
          spacing =                     mkLiteral "10px";
          padding =                     mkLiteral "15px";
          border-radius =               mkLiteral "10px";
          background-color =            mkForce (mkLiteral "@blue");
          text-color =                  mkForce (mkLiteral "@background");
          children =                    [ "textbox-prompt-colon" "entry" ];
        };

        textbox-prompt-colon = {
          enabled =                     true;
          expand =                      false;
          str =                         "";
          background-color =            mkForce (mkLiteral "inherit");
          text-color =                  mkForce (mkLiteral "inherit");
        };

        entry = {
          enabled =                     true;
          background-color =            mkForce (mkLiteral "inherit");
          text-color =                  mkForce (mkLiteral "inherit");
          cursor =                      mkLiteral "text";
          placeholder =                 "search";
          placeholder-color =           mkForce (mkLiteral "inherit");
        };

        mode-switcher = {
          enabled =                     true;
          spacing =                     mkLiteral "20px";
          background-color =            mkForce (mkLiteral "transparent");
          text-color =                  mkForce (mkLiteral "@background");
        };

        button = {
          padding =                     mkLiteral "15px";
          border-radius =               mkLiteral "10px";
          background-color =            mkForce (mkLiteral "@blue");
          text-color =                  mkForce (mkLiteral "inherit");
          cursor =                      mkLiteral "pointer";
        };

        "button selected" = {
          background-color =            mkForce (mkLiteral "@selected-normal-background");
          text-color =                  mkForce (mkLiteral "@background");
        };

        listview = {
          enabled =                     true;
          columns =                     1;
          lines =                       8;
          cycle =                       true;
          dynamic =                     true;
          scrollbar =                   false;
          layout =                      mkLiteral "vertical";
          reverse =                     false;
          fixed-height =                true;
          fixed-columns =               true;
          spacing =                     mkLiteral "10px";
          background-color =            mkForce (mkLiteral "transparent");
          text-color =                  mkForce (mkLiteral "@blue");
          cursor =                      "default";
        };

        element = {
          enabled =                     true;
          spacing =                     mkLiteral "15px";
          padding =                     mkLiteral "8px";
          border-radius =               mkLiteral "10px";
          background-color =            mkForce (mkLiteral "transparent");
          text-color =                  mkForce (mkLiteral "@blue");
          cursor =                      mkLiteral "pointer";
        };

        "element normal.normal" = {
          background-color =            mkForce (mkLiteral "inherit");
          text-color =                  mkForce (mkLiteral "inherit");
        };

        "element normal.urgent" = {
          background-color =            mkForce (mkLiteral "@red");
          text-color =                  mkForce (mkLiteral "@background");
        };

        "element normal.active" = {
          background-color =            mkForce (mkLiteral "@active-background");
          text-color =                  mkForce (mkLiteral "@background");
        };

        "element selected.normal" = {
          background-color =            mkForce (mkLiteral "@selected-normal-background");
          text-color =                  mkForce (mkLiteral "@background");
        };

        "element selected.urgent" = {
          background-color =            mkForce (mkLiteral "@selected-normal-background");
          text-color =                  mkForce (mkLiteral "@background");
        };

        "element selected.active" = {
          background-color =            mkForce (mkLiteral "@selected-normal-background");
          text-color =                  mkForce (mkLiteral "@background");
        };

        element-icon = {
          background-color =            mkForce (mkLiteral "transparent");
          text-color =                  mkForce (mkLiteral "inherit");
          size =                        mkLiteral "32px";
          cursor =                      mkLiteral "inherit";
        };

        element-text = {
          background-color =            mkForce (mkLiteral "transparent");
          text-color =                  mkForce (mkLiteral "inherit");
          cursor =                      mkLiteral "inherit";
          vertical-align =              mkLiteral "0.5";
          horizontal-align =            mkLiteral "0.0";
        };

        message = {
          background-color =            mkForce (mkLiteral "transparent");
        };

        textbox = {
          padding =                     mkLiteral "15px";
          border-radius =               mkLiteral "10px";
          background-color =            mkForce (mkLiteral "@blue");
          text-color =                  mkForce (mkLiteral "@background");
          vertical-align =              mkLiteral "0.5";
          horizontal-align =            mkLiteral "0.0";
        };

        error-message = {
          padding =                     mkLiteral "15px";
          border-radius =               mkLiteral "20px";
          background-color =            mkForce (mkLiteral "@background");
          text-color =                  mkForce (mkLiteral "@red");
        };
      };
    };
  };
}

