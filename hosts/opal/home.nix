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

  window-managers.hyprland.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
