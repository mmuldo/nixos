# media view/HTPC
{ pkgs, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  services.xserver = {
    enable = true;

    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = user.name;
      };
      # this is gnome wayland
      defaultSession = "gnome";
    };

    desktopManager.gnome.enable = true;
  };

  # needed to make autologin on gdm work
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  normal-users.${user.name} = {
    ssh.authorizedKeys = user.ssh.authorizedKeys;
  };

  users.users.root.openssh.authorizedKeys.keys = user.ssh.authorizedKeys;

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  nerdFonts.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-settings-daemon
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.hot-edge
    gnomeExtensions.user-themes
    jellyfin-media-player
    spotify
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    #gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

