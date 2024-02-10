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
      username = cfg.user.name;
      homeDirectory = "/home/${cfg.user.name}";
      sessionVariables = {
        EDITOR = cfg.editor;
      };
    };

    programs.git = {
      enable = true;
      includes = [{
        contents = {
          init.defaultBranch = "main";
          core.editor = cfg.editor;
        };
      }];
      userName = cfg.user.fullName;
      userEmail = cfg.user.email;
    };
  };
}
