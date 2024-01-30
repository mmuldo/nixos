{
  home.username = "matt";
  home.homeDirectory = "/home/matt";

  programs.git = {
    enable = true;
    includes = [{
      contents = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    }];
    userName = "Matt Muldowney";
    userEmail = "matt.muldowney@gmail.com";
  };
}
