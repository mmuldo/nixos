{ inputs, user, config, pkgs, ... }:
let
  weztermBackgroundImagePath = ".wallpapers/ryokan.png";

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

  terminal-emulators.wezterm = {
    enable = true;
    backgroundImagePath = "${config.home.homeDirectory}/${weztermBackgroundImagePath}";
    colorScheme = "Tokyo Night";
  };

  programs.firefox.enable = true;

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark-B";
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/desktop/background" =
      let
        pictureUri = "${config.home.homeDirectory}/.background-image";
      in
      {
        picture-uri = pictureUri;
        picture-uri-dark = pictureUri;
      };

      "org/gnome/desktop/screensaver".lock-enabled = false;
      "org/gnome/desktop/session".idle-delay = "uint32 0";
      "org/gnome/desktop/notifications" = {
        show-banners = false;
        show-in-lock-screen = false;
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

  home.file = {
    ".background-image".source = ../../wallpapers/tokyonight/gate.png;
    ".themes".source = ./themes;
    ${weztermBackgroundImagePath}.source = ../../wallpapers/tokyonight/ryokan.png;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
