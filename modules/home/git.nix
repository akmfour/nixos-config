# Git identity for commits. The repo is public, so use GitHub's noreply
# address instead of a real one. `gh` (modules/home/gh.nix) is registered as
# the HTTPS credential helper, so `git push` reuses the `gh auth login` token.
{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "suzumiya";
        email = "21970464+akmfour@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.gh.gitCredentialHelper.enable = true;
}
