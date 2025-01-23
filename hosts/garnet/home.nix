{ inputs, user, config, pkgs, ... }:
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
    sessionPath = [];
  };

  shells.zsh.enable = true;

  terminal-emulators.alacritty.enable = true;

  programs.firefox.enable = true;

  gtk.enable = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/desktop/screensaver" = {
        lock-enabled = false;
        idle-activation-enabled = false;
      };
      "org/gnome/desktop/session".idle-delay = "uint32 0";
      "org/gnome/desktop/notifications" = {
        show-banners = false;
        show-in-lock-screen = false;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        ambient-enabled = false;
        idle-dim = false;
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-ac-timeout = 0;
      };
    };
  };

  xdg.desktopEntries = builtins.listToAttrs (map webDesktopEntry [
    { name = "crunchyroll"; }
    { name = "hulu"; }
    { name = "netflix"; }
    { name = "streameast"; website = "streameast.xyz"; }
    { name = "youtube"; }
  ] );

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
