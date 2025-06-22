{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.window-managers.hyprland;
in
{
  options.window-managers.hyprland = {
    enable = mkEnableOption "hyprland";

    mod = mkOption {
      type = types.str;
      default = "super";
    };

    terminal = mkOption {
      type = types.str;
      default = "alacritty";
    };

    menu = mkOption {
      type = types.str;
      default = "rofi";
    };

    passmenu = mkOption {
      type = types.str;
      default = "ROFI_PASS_BACKEND=wtype ROFI_PASS_CLIPBOARD_BACKEND=wl-clipboard rofi-pass";
    };

    wallpaperPath = mkOption {
      type = with types; nullOr path;
      default = config.stylix.image;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;

      settings = {
        env = [
          "XCURSOR_SIZE,24"
        ];

        exec-once = mkMerge [
          (mkIf (cfg.wallpaperPath != null) [
             "swww init"
             "swww img ${cfg.wallpaperPath}"
          ])

          [
            "which ibus-daemon && ibus-daemon -rxRd"
            "waybar &"
          ]
        ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_rules = "";
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          layout = "master";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.25, 0.9, 0.1, 1.02";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            # "workspaces, 1, 3, default, slidevert"
            # "workspaces, 1, 3, myBezier, slidefadevert"
            "workspaces, 1, 3, myBezier, fade"
          ];
        };

        master = {
          new_status = "master";
        };

        bind = with cfg; [
          "${mod}, return, exec, ${terminal}"
          "${mod}, x, killactive"
          "${mod}, f, fullscreen"
          "${mod}, t, togglefloating"
          "${mod}, d, exec, ${menu} -filebrowser-show-hidden true -show drun"
          "${mod}, s, exec, ${menu} -filebrowser-show-hidden true -show ssh"
          "${mod}, o, exec, ${menu} -show power-menu -modi power-menu:${menu}-power-menu"
          "${mod}, p, exec, ${passmenu}"
          "${mod}, b, exec, if [ \"$(ibus engine)\" = 'OpenBangla' ]; then ibus engine xkb:us::eng; else ibus engine OpenBangla; fi"
        ]
        ++ builtins.concatLists (builtins.attrValues (builtins.mapAttrs (key: action: [
          "${mod}, ${key}, movefocus, ${action}"
          "${mod} shift, ${key}, movewindow, ${action}"
        ]) {
          h = "l";
          l = "r";
          k = "u";
          j = "d";
        }))
        ++ builtins.concatMap (n: [
          "${mod}, ${toString n}, workspace, ${toString (if n == 0 then 10 else n)}"
          "${mod} shift, ${toString n}, movetoworkspace, ${toString (if n == 0 then 10 else n)}"
        ]) [1 2 3 4 5 6 7 8 9 0];

        bindm = with cfg; [
          "${mod}, mouse:272, movewindow"
          "${mod}, mouse:273, resizewindow"
        ];

        layerrule = "blur, waybar";
      };
    };

    menus.rofi = {
      enable = true;
      backgroundImagePath = ../../../wallpapers/catppuccin/default.png;
    };

    home.packages = with pkgs; [
      wl-clipboard
      wtype
      xdg-utils
    ];
  };
}
