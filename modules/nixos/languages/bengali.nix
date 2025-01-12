{ lib, pkgs, config, ... }:

with lib;
let
cfg = config.languages.bengali;
in
{
  options.languages.bengali = {
    enable = mkEnableOption "bengali language features";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ openbangla-keyboard ];
    };
  };
}
