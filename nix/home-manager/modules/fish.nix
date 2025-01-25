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
          path = "echo $PATH | tr ':' '\n'";
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

                  set -g fish_greeting ""

                  # Initialize Starship
                  # starship init fish | source
          	direnv hook fish | source
        '';
      }
      (lib.mkIf (!pkgs.stdenv.isDarwin) {
        enable = true;
      })
    ];
  };
}
