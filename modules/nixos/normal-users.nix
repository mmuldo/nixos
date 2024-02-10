{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.normal-users;

  userOpts = {
    options = {
      ssh.authorizedKeys = mkOption {
        type = with types; listOf str;
      };

      shell = mkOption {
        type = types.str;
        default = "zsh";
      };

      extraGroups = mkOption {
        type = with types; listOf str;
        default = [ "wheel" ];
      };
    };
  };

  hasZshUser = any (opts: opts.shell == "zsh") (attrValues cfg);
in
{
  options.normal-users = mkOption {
    type = with types; attrsOf (submodule userOpts);
    default = {};
  };

  config = mkIf (cfg != {}) (mkMerge [
    {
      i18n.defaultLocale = "en_US.UTF-8";

      security.sudo.wheelNeedsPassword = false;
    
      users.users = mapAttrs (name: opts: {
        isNormalUser = true;
        inherit (opts) extraGroups;
        shell = pkgs.${opts.shell};
        openssh.authorizedKeys.keys = opts.ssh.authorizedKeys;
      }) cfg;

    }

    (mkIf hasZshUser {
      programs.zsh.enable = true;
      environment.pathsToLink = [ "/share/zsh" ];
    })
  ]);
}
