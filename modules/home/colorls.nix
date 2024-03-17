{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.colorls;
in
{
  options.colorls = {
    enable = mkEnableOption "colorls";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      colorls
    ];

    home.file.".config/colorls/dark_colors.yaml".text = with config.colorscheme.palette; ''
      # Main Colors
      unrecognized_file: '#${base09}' # Gold
      recognized_file: '#${base05}' # Text
      executable_file: '#${base0C}' # Foam
      dir: '#${base0A}' # Rose
      
      # Link
      dead_link: '#${base08}' # Love
      link: '#${base0C}' # Foam
      
      # Special Files
      socket: '#${base0B}' # Pine
      blockdev: '#${base0B}' # Pine
      chardev: '#${base0B}' # Pine
      
      # Access Modes
      write: '#${base0A}' # Rose
      read: '#${base0D}' # Iris
      exec: '#${base0B}' # Foam
      no_access: '#${base08}' # Love
      
      # Age
      hour_old: '#${base04}' # Subtle
      day_old: '#${base03}' # Muted
      no_modifier: '#${base0F}' # Current Line
      
      # File Size
      file_large: '#${base08}' # Love
      file_medium: '#${base09}' # Gold
      file_small: '#${base0A}' # Rose
      
      # Random
      report: '#${base0A}' # Rose
      user: '#${base0C}' # Foam
      tree: '#${base0F}' # Current Line
      empty: '#${base03}' # Muted
      error: '#${base08}' # Love
      normal: '#${base05}' # Text
      
      # Git
      addition: '#${base0C}' # Foam
      modification: '#${base0D}' # Iris
      deletion: '#${base08}' # Love
      untracked: '#${base09}' # Gold
      unchanged: '#${base0B}' # Pine
    '';
  };
}
