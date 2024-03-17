# TODO: make more configurable and separate p10k config
{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.shells.zsh;
in
{
  options.shells.zsh = {
    enable = mkEnableOption "zsh (with oh-my-zsh) config";
  };
  
  config = mkIf cfg.enable {
    colorls.enable = true;

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      initExtra = ''
        zvm_after_init_commands+=("bindkey -M viins '^ ' autosuggest-accept")
        zvm_after_init_commands+=("bindkey -M vicmd '^ ' autosuggest-accept")
        zvm_after_init_commands+=("bindkey -M visual '^ ' autosuggest-accept")
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
      };
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
        ls = "colorls";
        l = "colorls -al";
      };
      plugins = [
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./.;
          file = "p10k.zsh";
        }
      ];
    };
  };
}
