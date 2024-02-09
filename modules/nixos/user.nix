{ pkgs, user, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;

  users.users.${user.name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = user.ssh.authorizedKeys;
  };

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
