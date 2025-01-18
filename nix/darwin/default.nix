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

    # https://github.com/LnL7/nix-darwin/issues/122
    fish.shellInit = # fish
      ''
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
