{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.pass;
in
{
  options.pass = {
    enable = mkEnableOption "pass for unix";

    pinentryPackage = mkOption {
      type = types.package;
      description = "pinentry package for entering gpg password";
      default = pkgs.pinentry-gtk2;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.pinentryPackage
      pass
    ];

    programs.browserpass.enable = true;

    programs.gnupg.agent = {
      enable = true;
      inherit (cfg) pinentryPackage;
    };
  };
}
