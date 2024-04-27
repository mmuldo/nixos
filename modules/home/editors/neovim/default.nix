{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.editors.neovim;
  colorschemePlugin = pkgs.vimUtils.buildVimPlugin {
    name = "colorscheme";
    src = ./colorschemes/${cfg.colorscheme.name};
  };
in
{
  options.editors.neovim = {
    enable = mkEnableOption "personal neovim config";

    colorscheme = {
      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.rose-pine;
      };
      name = mkOption {
        type = types.str;
        default = "rose-pine";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      extraPackages = with pkgs; [
        # dependencies
        wl-clipboard
        ripgrep

        # language servers
        lua-language-server
        nixd
        rust-analyzer
      ];

      plugins = [
        cfg.colorscheme.package
        colorschemePlugin

        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.telescope-nvim
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        pkgs.vimPlugins.neodev-nvim
        pkgs.vimPlugins.nvim-lspconfig
        pkgs.vimPlugins.cmp-nvim-lsp
        pkgs.vimPlugins.nvim-cmp
        pkgs.vimPlugins.luasnip
        pkgs.vimPlugins.cmp_luasnip
        pkgs.vimPlugins.cmp_luasnip
        pkgs.vimPlugins.cmp-path
        pkgs.vimPlugins.rustaceanvim
      ];

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

    home.file.".config/nvim".source = ./nvim;
  };
}
