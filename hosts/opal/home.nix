{ inputs, user, config, pkgs, ... }:
{
  imports = [
    inputs.self.outputs.homeManagerModules.default
  ];

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  user = {
    inherit (user) name fullName email;
  };

  shells.zsh.enable = true;

  terminal-emulators.alacritty.enable = true;

  window-managers.hyprland = {
    enable = true;
    wallpaperPath = ../../wallpapers/dracula/nightmare-before-christmas-schreme.gif;
  };

  colorscheme = inputs.nix-colors.colorSchemes.dracula;

  spicetify = {
    enable = true;
    theme = "catppuccin";
    colorscheme = "mocha";
  };

  cava.enable = true;

  bars.waybar.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
  };

  zathura.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
