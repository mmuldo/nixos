# personal workstation
{ pkgs, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  programs.hyprland.enable = true;

  normal-users.${user.name} = {
    ssh.authorizedKeys = user.ssh.authorizedKeys;
  };

  editors.neovim.enable = true;

  nerdFonts.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    brave
  ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

