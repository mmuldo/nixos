{ lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    includes = [{
      contents = {
        init.defaultBranch = "main";
	# is it possible to make this like a pkg.nvim?
	core.editor = "nvim";
      };
    }];
    userName = "Matt Muldowney";
    userEmail = "matt.muldowney@gmail.com";
  };
}
