{
  pkgs,
  inputs,
}:

let
  overlays = [
    inputs.self.overlays.macos
    inputs.self.overlays.nodePackages
  ];
in
{
  systems = {
    "work" = {
      username = "ss";
      homeDirectory = "/Users/ss";
      system = "aarch64-darwin";
      defaultSopsFile = ../secrets/work.yaml;
    };
    "personal" = {
      username = "ervan";
      homeDirectory = "/Users/ervan";
      system = "aarch64-darwin";
      defaultSopsFile = ../secrets/personal.yaml;
    };
    "vm" = {
      username = "ervan";
      homeDirectory = "/home/ervan";
      system = "aarch64-linux";
      defaultSopsFile = ../secrets/vm.yaml;
    };
  };

  # Helper function for darwin configuration
  mkDarwin =
    nixpkgs:
    {
      system,
      username,
      homeDirectory,
      defaultSopsFile,
    }:

    inputs.darwin.lib.darwinSystem {
      inherit system;
      pkgs = import nixpkgs {
        inherit system overlays;
      };

      modules = [
        ../nix/darwin
        {
          users.users.${username}.home = homeDirectory;
        }

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports = [
                inputs.sops-nix.homeManagerModules.sops
                ../nix/home-manager
              ];
              _module.args = {
                inherit
                  inputs
                  username
                  homeDirectory
                  defaultSopsFile
                  ;
                isNixDarwin = true;
              };
            };
          };
        }
      ];
    };

  # Helper function for home-manager configuration
  mkHome =
    nixpkgs:
    {
      system,
      username,
      homeDirectory,
      defaultSopsFile,
    }:

    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system overlays;
      };

      modules = [
        inputs.sops-nix.homeManagerModules.sops
        ../nix/home-manager
        {
          _module.args = {
            inherit
              inputs
              username
              homeDirectory
              defaultSopsFile
              ;
            isNixDarwin = false;
          };
        }
      ];
    };
}
