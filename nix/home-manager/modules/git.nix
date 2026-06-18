{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.modules.git = {
    enable = lib.mkEnableOption "git configuration";
  };

  config = lib.mkIf config.modules.git.enable {
    home.packages = [

    ];

    # Write the git identity into ~/.gitconfig.local once per activation.
    # This used to run on every git invocation via a package wrapper, which
    # locked ~/.gitconfig.local each time and made parallel git calls (e.g.
    # eas build) fail with "could not lock config file ... File exists".
    # Reading from the sops secret path keeps the values out of the nix store.
    home.activation.gitLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.git}/bin/git config --file "$HOME/.gitconfig.local" user.email "$(cat ${config.sops.secrets.email.path})"
      ${pkgs.git}/bin/git config --file "$HOME/.gitconfig.local" user.name "$(cat ${config.sops.secrets.username.path})"
    '';

    programs.git = {
      enable = true;
      package = pkgs.git;
      includes = [
        { path = "~/.gitconfig.local"; }
      ];

      settings = {
        alias = {
        # Common shortcuts
        st = "status";
        co = "checkout";
        br = "branch";
        cp = "cherry-pick";
        cl = "clone";
        diff = "diff --word-diff";
        dc = "diff --cached";

        # Logging
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        last = "log -1 HEAD --stat";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";

        # Branch management
        bd = "branch -d";
        bD = "branch -D";

        # Commit related
        aa = "add --all";
        cm = "commit -m";
        amend = "commit --amend";
        unstage = "reset HEAD --";
        undo = "reset HEAD~1 --mixed";

        # Push/Pull
        ps = "push";
        pl = "pull";
        pf = "push --force-with-lease";

        # Stash
        ss = "stash save";
        sp = "stash pop";
        sl = "stash list";

        # Clean up
        cleanup = "clean -df";
        purge = "clean -fdx";

        # Show changes
        changes = "diff --name-status";
        who = "shortlog -s --";

        # Utils
        aliases = "config --get-regexp alias";
        tags = "tag -l";
        remotes = "remote -v";
        contributors = "shortlog --summary --numbered";
        };
      };
    };
  };
}
