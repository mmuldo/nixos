{ user, ...}:
{
  home = {
    username = user.name;
    homeDirectory = "/home/" + user.name;
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.git = {
    enable = true;
    includes = [{
      contents = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    }];
    userName = user.fullName;
    userEmail = user.email;
  };
}
