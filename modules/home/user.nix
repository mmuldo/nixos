{ lib, config, ...}:

with lib;
let
  cfg = config.user;
in
{
  options.user = {
    name = mkOption {
      type = types.str;
    };

    fullName = mkOption {
      type = types.str;
    };

    email = mkOption {
      type = types.str;
    };

    editor = mkOption {
      type = types.str;
      default = "nvim";
    };
  };

  config = {
    home = {
      username = cfg.name;
      homeDirectory = "/home/${cfg.name}";
      sessionVariables = {
        EDITOR = cfg.editor;
      };
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
      ];
    };

    programs.git = {
      enable = true;
      includes = [{
        contents = {
          init.defaultBranch = "main";
          core.editor = cfg.editor;
        };
      }];
      userName = cfg.fullName;
      userEmail = cfg.email;
    };
  };
}
