{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.window-managers.hyprland;

  mod = "super";
  terminal = "kitty";
  menu = "wofi --show drun";
in
{
  options.window-managers.hyprland = {
    enable = mkEnableOption "hyprland";
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

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
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
          new_is_master = true;
        };

        bind = [
          "${mod}, return, exec, ${terminal}"
          "${mod}, x, killactive"
          "${mod}, f, fullscreen"
          "${mod}, t, togglefloating"
          "${mod}, d, exec, ${menu}"

          #"${mod}, h, movefocus, l"
          #"${mod}, l, movefocus, r"
          #"${mod}, k, movefocus, u"
          #"${mod}, j, movefocus, d"

          #"${mod} shift, h, movewindow, l"
          #"${mod} shift, l, movewindow, r"
          #"${mod} shift, k, movewindow, u"
          #"${mod} shift, j, movewindow, d"
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
      };
    };

    home.packages = with pkgs; [
      wofi
    ];
  };
}
