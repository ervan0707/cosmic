{ pkgs, config, ... }:
{
  imports = [
    ./nix.nix
    ./system.nix
    ./services
  ];

  environment = with pkgs; {
    systemPackages = [

    ];

    # Add shells installed by nix to /etc/shells file
    shells = [ fish ];

    # Environment Variables
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  programs = {
    fish.enable = true;

    fish.shellInit = # fish
      ''
        function ndev
           # List of supported languages
           set -l valid_languages go lua nix node php python rust

           if test (count $argv) = 0
             echo "Usage: ndev <language>"
             echo "Supported languages: $valid_languages"
             return 1
           end

           set -l requested_lang $argv[1]

           if contains $requested_lang $valid_languages
             nix develop github:Ervan0707/cosmic#$requested_lang
           else
             echo "Error: '$requested_lang' is not supported"
             echo "Supported languages: $valid_languages"
             return 1
           end
         end

        # https://github.com/LnL7/nix-darwin/issues/122
        for p in (string split : ${config.environment.systemPath})
          if not contains $p $fish_user_paths
            set -g fish_user_paths $fish_user_paths $p
          end
        end
      '';
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true; # Enable Touch ID for sudo

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
