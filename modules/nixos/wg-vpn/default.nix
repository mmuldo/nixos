{ lib, config, host, ... }:

with lib;
let
  cfg = config.wg-vpn;
in
{
  imports = [
    ./client.nix
    ./server.nix
  ];

  options.wg-vpn = {
    enable = mkEnableOption "wireguard";

    agePrivateKeyFile = mkOption {
      type = types.path;
      default = ../../../secrets/wg-keys/${host}.age;
    };

    privateKeyFile = mkOption {
      type = types.path;
      description = "defaults to age file path";
      default = config.age.secrets.wg-key.path;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.wg-key.file = cfg.agePrivateKeyFile;
  };
}
