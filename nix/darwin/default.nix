{
  pkgs,
  config,
  username,
  ...
}:
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
            echo "Special: nodejs_<version> (e.g., nodejs_18, nodejs_20)"
            return 1
          end

          set -l requested_lang $argv[1]

          # Check if it's a nodejs version request
          if string match -q "nodejs_*" $requested_lang
            nix develop github:Ervan0707/cosmic#$requested_lang
          else if contains $requested_lang $valid_languages
            nix develop github:Ervan0707/cosmic#$requested_lang
          else
            echo "Error: '$requested_lang' is not supported"
            echo "Supported languages: $valid_languages"
            echo "Special: nodejs_<version> (e.g., nodejs_18, nodejs_20)"
            return 1
          end
        end

        # https://github.com/nix-darwin/nix-darwin/issues/122
        for p in (string split : ${config.environment.systemPath})
          if not contains $p $fish_user_paths
            set -g fish_user_paths $fish_user_paths $p
          end
        end
      '';
  };

  security.pam.services.sudo_local.touchIdAuth = true; # Enable Touch ID for sudo

  # Make fish the login shell. users.users.<name>.shell only applies to users in
  # users.knownUsers, which would also need a hardcoded uid per host, so set it directly.
  system.activationScripts.postActivation.text = ''
    fishPath=/run/current-system/sw/bin/fish
    if [ "$(dscl . -read /Users/${username} UserShell | awk '{print $2}')" != "$fishPath" ]; then
      echo "setting login shell of ${username} to $fishPath" >&2
      chsh -s "$fishPath" ${username}
    fi
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
