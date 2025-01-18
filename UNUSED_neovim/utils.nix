{ pkgs }:

{
  fGit =
    owner: repo: rev: sha:
    pkgs.vimUtils.buildVimPlugin {
      pname = repo;
      version = "03-12-2024";
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = rev;
        sha256 = sha;
      };
    };
}
