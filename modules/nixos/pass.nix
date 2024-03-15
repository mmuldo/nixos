{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.pass;
in
{
  options.pass = {
    enable = mkEnableOption "pipewire audio backend";

    pinentry = {
      flavor = mkOption {
        type = types.str;
        description = "gpg pinentry flavor for entering password";
        default = "curses";
      };

      package = mkOption {
        type = types.package;
        description = "pinentry package which includes pinentry flavor";
        default = pkgs.pinentry-curses;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.pinentry.package
      pass
    ];

    programs.browserpass.enable = true;

    programs.gnupg.agent = {
      enable = true;
      pinentryFlavor = cfg.pinentry.flavor;
    };
  };
}
