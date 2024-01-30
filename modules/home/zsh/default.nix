{ lib, pkgs, ... }:

{
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
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    syntaxHighlighting = {
      enable = true;
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
}
