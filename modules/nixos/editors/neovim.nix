{ lib, pkgs, config, inputs, system, ... }:

with lib;
let
  cfg = config.editors.neovim;
in
{
  options.editors.neovim = {
    enable = mkEnableOption "personal neovim config";

    colorscheme = mkOption {
      type = types.str;
      default = "default";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # dependency for telescope.nvim
      ripgrep
      inputs.mmuldo-neovim.packages.${system}.${cfg.colorscheme}
    ];
  };
}
