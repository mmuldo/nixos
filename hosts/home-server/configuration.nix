{ config, lib, pkgs, inputs, system, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/nixos/user.nix
    ../../modules/nixos/jellyfin.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit user;
    };
    users.${user.name} = import ./home.nix;
  };

  boot.loader = {
    timeout = 0;
    grub = {
      enable = true;
      device = "/dev/sda";
      timeoutStyle = "hidden";
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    inputs.mmuldo-neovim.packages.${system}.default
    vim
    wget
    git
    ripgrep
    gcc
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

