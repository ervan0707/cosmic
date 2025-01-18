{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixvim,
      ...
    }:
    let
      config = import ./config;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = config;
          extraSpecialArgs = {

          };
        };
      in
      {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };

        packages.default = pkgs.symlinkJoin {
          name = "nixvim-with-tools";
          paths = with pkgs; [
            nvim
            ripgrep
            tree-sitter

            tailwindcss-language-server
            prettierd
            eslint_d
            typescript-language-server

            gopls
            gomodifytags
            golangci-lint
            impl

            stylua
            lua-language-server

            nixd
            nixfmt-rfc-style

            pyright
            ruff

            rust-analyzer
            rustfmt

          ];
        };
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      }
    );
}
