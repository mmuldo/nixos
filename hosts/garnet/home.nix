{ inputs, user, ... }:
let
  webDesktopEntry = { name, website ? "${name}.com" }: {
    inherit name;
    value = {
      inherit name;
      exec = "firefox ${website}";
      terminal = false;
      icon = name;
    };
  };
in
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

  programs.firefox.enable = true;

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  xdg.desktopEntries = builtins.listToAttrs (map webDesktopEntry [
    { name = "netflix"; }
    { name = "youtube"; }
    { name = "hulu"; }
    { name = "streameast"; website = "streameast.xyz"; }
  ] );

  # xdg.desktopEntries = {
  #   netflix = {
  #     name = "Netflix";
  #     exec = "firefox netflix.com";
  #     terminal = false;
  #     icon = "netflix2";
  #   };

  #   youtube = {
  #     name = "YouTube";
  #     exec = "firefox youtube.com";
  #     terminal = false;
  #     icon = "youtube";
  #   };
  # };

  xdg.dataFile = {
    icons = {
      enable = true;
      target = "icons";
      source = ./icons;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
