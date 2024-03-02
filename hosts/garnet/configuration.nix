# media view/HTPC
{ pkgs, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  normal-users.${user.name} = {
    ssh.authorizedKeys = [];
  };

  editors.neovim.enable = true;

  nerdFonts.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.hot-edge
  ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

