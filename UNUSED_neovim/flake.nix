{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        utils = import ./utils.nix { inherit pkgs; };
        inherit (utils) fGit;
        neovim-config = pkgs.vimUtils.buildVimPlugin {
          pname = "neovim-config";
          version = "1.0.0";
          src = ./.;
        };
      in
      {

        packages.default = pkgs.symlinkJoin {
          name = "neovim-with-tools";
          paths = [
            (pkgs.neovim.override {
              # your existing neovim configuration
              configure = {
                packages.myPlugins = with pkgs.vimPlugins; {
                  start = [
                    neovim-config
                    plenary-nvim
                    telescope-nvim
                    nvim-web-devicons
                    mini-icons
                    nvim-tree-lua

                    # theme
                    catppuccin-nvim

                    # ui
                    noice-nvim
                    nui-nvim
                    nvim-notify
                    actions-preview-nvim
                    indent-blankline-nvim

                    lualine-nvim
                    bufferline-nvim

                    nvim-navic
                    nvim-lspconfig

                    lspkind-nvim
                    luasnip
                    cmp-nvim-lsp
                    cmp-buffer
                    nvim-cmp

                    nvim-treesitter
                    nvim-treesitter.withAllGrammars

                    none-ls-nvim

                    (fGit "nvimtools" "none-ls-extras.nvim" "f50d4dece9f91813f049f8100d188933f7d654d9"
                      "07arvl5pkxkl4011i1b3crghwps33dp4r8rbl22dssxnxgjblplf"
                    )
                    nvim-ts-autotag
                    nvim-autopairs
                    gitsigns-nvim
                    (fGit "ervan0707" "codestats.nvim" "e17f60f4a63c83c1422d10481eae723551906133"
                      "0w534a88wfh04484v1wd1csiqkkxj2s8l262wnzdb2iffmbidwlr"
                    )

                    which-key-nvim

                  ];
                };
                customRC = ''
                  lua require('config')
                '';
              };
            })
            pkgs.ripgrep
            pkgs.nodePackages_latest.typescript-language-server
            pkgs.tree-sitter
            pkgs.prettierd
            pkgs.eslint_d

            pkgs.gopls
            pkgs.gomodifytags
            pkgs.impl
            pkgs.stylua
            pkgs.lua-language-server

          ];
        };
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      }
    );
}
