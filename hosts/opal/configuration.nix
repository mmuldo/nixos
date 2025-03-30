# personal workstation
{
  pkgs,
  user,
  inputs,
  system,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  normal-users.${user.name} = {
    ssh.authorizedKeys = user.ssh.authorizedKeys;
  };

  pipewire.enable = true;

  pass.enable = true;

  dropbox.enable = true;

  wg-vpn = {
    enable = false;

    client = {
      enable = false;
      interface.ipv4.address = "10.0.0.3";
      server = {
        publicKey = "fVm8OYWhwqFRr9QCQO4W/TDxUaEBCL6brXfnTXqhODw=";
        ipv4.publicAddress = "45.79.82.159";
      };
    };
  };

  daw.enable = true;

  games.enable = true;

  neovim.enable = true;

  languages.bengali.enable = true;

  stylix = {
    enable = true;
    image = ../../wallpapers/catppuccin/four-eyed-cat.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMonoNerdFontMono";
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
  };

  environment.systemPackages = with pkgs; [
    brave
    swww
    mpvpaper
    inputs.agenix.packages.${system}.default
    killall
    mpv
    anki-bin
  ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
