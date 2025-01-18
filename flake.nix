{
  description = "Dancing in the wind, as roses born again ✨";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "path:./nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-gruvbox = {
      url = "github:egel/tmux-gruvbox";
      flake = false;
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      lib = import ./lib {
        inherit inputs;
        pkgs = import inputs.nixpkgs { };
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Get systems from utils.systems keys and map them to include their architecture
      systems = builtins.attrValues (builtins.mapAttrs (name: value: value.system) lib.utils.systems);
      imports = [
        ./overlays
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # Development shells
          devShells = import ./nix/devShells { inherit pkgs; };

          # NixVim package and app
          packages = {
            nixvim = inputs.nixvim.packages.${system}.default;
            default = inputs.nixvim.packages.${system}.default;
          };

          apps = {
            nixvim = inputs.nixvim.apps.${system}.default;
            default = inputs.nixvim.apps.${system}.default;
          };
        };

      flake =
        let
          inherit (lib.utils) systems mkHome mkDarwin;
        in
        {
          # Home Manager configurations
          homeConfigurations = builtins.mapAttrs (name: cfg: mkHome inputs.nixpkgs cfg) systems;

          # Nix Darwin configurations
          darwinConfigurations = builtins.mapAttrs (name: cfg: mkDarwin inputs.nixpkgs cfg) systems;
        };
    };
}
