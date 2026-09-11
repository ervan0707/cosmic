{
  description = "Dancing in the wind, as roses born again ✨";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Node pinned to exactly 22.11.0. nixpkgs keeps only one patch level per
    # major, and nixpkgs-unstable's nodejs_22 has moved on to 22.23.x, so the
    # version has to come from an older rev. This is a nixpkgs-unstable channel
    # rev from before e4f44407a7a9 ("nodejs_22: 22.11.0 -> 22.12.0", 2024-12-25),
    # picked because its aarch64-darwin build is still in cache.nixos.org —
    # no source build. Deliberately does NOT follow nixpkgs; it *is* a nixpkgs.
    nixpkgs-node.url = "github:nixos/nixpkgs/c792c60b8a97daa7efe41a6e4954497ae410e0c1";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim = {
    #   url = "github:Ervan0707/cosmic?dir=nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    tmux-gruvbox = {
      url = "github:egel/tmux-gruvbox";
      flake = false;
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # sketchybar-app-font = {
    #   url = "github:kvndrsslr/sketchybar-app-font";
    #   flake = false;
    # };
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
        # ./overlays
        # ./overlays/pkgs/nodePkgs
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
          devShells = import ./nix/devShells { inherit pkgs inputs; };

          # NixVim package and app
          packages = {
            # nixvim = inputs.nixvim.packages.${system}.default;
            # default = inputs.nixvim.packages.${system}.default;
          };

          apps = {
            # nixvim = inputs.nixvim.apps.${system}.default;
            # default = inputs.nixvim.apps.${system}.default;
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
