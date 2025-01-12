{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.games;
in
{
  options.games = {
    enable = mkEnableOption "gaming";
  };


  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["amdgpu"];

    environment.systemPackages = with pkgs; [
      mangohud
      lutris
      prismlauncher
    ];

    programs.gamemode.enable = true;
  };
}
