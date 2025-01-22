{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.neovim;
in {
  options.neovim = {
    enable = mkEnableOption "neovim with some lsps and other goodies";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim

      # lsp
      lua-language-server
      nixd

      # formatters
      alejandra # nix

      # dependencies
      git
      fzf
      fd
      ripgrep

      # compiling
      gcc
    ];

    # for nixd
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
