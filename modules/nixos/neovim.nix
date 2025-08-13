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
      clang-tools

      # formatters
      alejandra # nix

      # debuggers
      #lldb_17 # TODO: causing failed build, figure out why

      # dependencies
      git
      fzf
      fd
      ripgrep

      # compiling
      gcc
      cmake
      gnumake
      pkg-config
    ];

    # for nixd
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
