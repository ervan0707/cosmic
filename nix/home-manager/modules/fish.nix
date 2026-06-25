{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.modules.fish = {
    enable = lib.mkEnableOption "fish configuration";
  };

  config = lib.mkIf config.modules.fish.enable {

    # custom paths to PATH (declarative, stateless, survives rebuilds)
    home.sessionPath = [ "$HOME/.local/bin" ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fish = lib.mkMerge [
      {
        shellAliases = {
          # Navigation
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";

          # List directory contents
          ls = "ls --color=auto";
          ll = "ls -alF";
          la = "ls -A";
          l = "ls -CF";

          # Directory operations
          md = "mkdir -p";
          rd = "rmdir";

          # System
          c = "clear";
          h = "history";
          # NOTE: do NOT name this `path`. That shadows fish's builtin `path`
          # command, which fish's own completions call (e.g. `path filter` in
          # git.fish). The shadowing leaked `tr: extra operand 'filter'` errors
          # while typing git commands. `string split` also drops the tr dependency.
          showpath = "string split ':' $PATH";
          ports = "netstat -tulanp";

          # Network
          myip = "curl http://ipecho.net/plain; echo";
          ping = "ping -c 5";

          # File operations
          cp = "cp -iv";
          mv = "mv -iv";
          rm = "rm -iv";

          # Grep with color
          grep = "grep --color=auto";
          egrep = "egrep --color=auto";
          fgrep = "fgrep --color=auto";

          # Directory size
          dux = "du -h -x --max-depth=1 | sort -h";
          dus = "du -sh";

          # Process management
          psa = "ps aux";
          psgrep = "ps aux | grep";

          # Quick directory jumps
          docs = "cd ~/Documents";

          # System monitoring
          mem = "free -h";
          cpu = "top -o cpu";
        };

        functions = {
          # Rebuild from the published config on GitHub (any machine, no local
          # clone needed). Auto-selects the profile from $USER and pulls
          # prebuilt binaries from the skinnyvans cachix cache.
          # `command -v` resolves the absolute path so sudo (which strips PATH
          # to a secure_path) can still find darwin-rebuild.
          rebuild = ''
            set -l profile
            switch $USER
              case ss;    set profile work
              case ervan; set profile personal
              case '*';   echo "No profile for user $USER"; return 1
            end
            echo "🔧 Rebuilding $profile from github:Ervan0707/cosmic"
            # --refresh bypasses the flake tarball cache (~1h TTL) so a rebuild
            # run right after a push picks up the just-pushed commit instead of
            # a stale cached tree.
            sudo (command -v darwin-rebuild) switch --refresh --flake github:Ervan0707/cosmic#$profile
          '';

          # Rebuild from the local working copy — use while editing config, to
          # test uncommitted changes before pushing. Run from inside the clone.
          rebuild-local = ''
            set -l profile
            switch $USER
              case ss;    set profile work
              case ervan; set profile personal
              case '*';   echo "No profile for user $USER"; return 1
            end
            echo "🔧 Rebuilding $profile from local working copy"
            sudo (command -v darwin-rebuild) switch --flake .#$profile
          '';
        };

        interactiveShellInit = ''
          set -g fish_color_autosuggestion '555'  'brblack'
          set -g fish_color_cancel -r
          set -g fish_color_command --bold
          set -g fish_color_comment red
          set -g fish_color_cwd green
          set -g fish_color_cwd_root red
          set -g fish_color_end brmagenta
          set -g fish_color_error brred
          set -g fish_color_escape 'bryellow'  '--bold'
          set -g fish_color_history_current --bold
          set -g fish_color_host normal
          set -g fish_color_match --background=brblue
          set -g fish_color_normal normal
          set -g fish_color_operator bryellow
          set -g fish_color_param cyan
          set -g fish_color_quote yellow
          set -g fish_color_redirection brblue
          set -g fish_color_search_match 'bryellow'  '--background=brblack'
          set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
          set -g fish_color_user brgreen
          set -g fish_color_valid_path --underline

          set -x CODESTATS_API_KEY $(cat ${config.sops.secrets.codestats_api_key.path})
          set -x GITHUB_TOKEN $(cat ${config.sops.secrets.github_token.path})
          set -x EXPO_APPLE_APP_SPECIFIC_PASSWORD $(cat ${config.sops.secrets.expo_apple_app_spesific_password.path})
          set -x GITLAB_TOKEN $(cat ${config.sops.secrets.gitlab_token.path})

          set -g fish_greeting ""

          # Initialize Starship
          # starship init fish | source
          direnv hook fish | source
                '';
      }

      {
        enable = true;
      }
      # (lib.mkIf (!pkgs.stdenv.isDarwin) {
      #   enable = true;
      # })
    ];
  };
}
