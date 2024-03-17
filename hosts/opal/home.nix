{ inputs, user, ... }:
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
    wallpaperPath = ../../wallpapers/rose-pine/mario.gif;
  };

  colorscheme = inputs.nix-colors.colorSchemes.rose-pine;

  spicetify = {
    enable = true;
    theme = "Ziro";
    colorscheme = "rose-pine";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
