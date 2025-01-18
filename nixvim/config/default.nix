{ pkgs, ... }:
{

  imports = [
    ./colors.nix
    ./noice.nix
    ./lualine.nix
    ./nvim-tree.nix
    ./bufferline.nix
    ./etc.nix
    ./lsp.nix
    ./telescope.nix
    ./gitsigns.nix
    ./actions-preview.nix
    ./which-key.nix
  ];

  vimAlias = true;

  opts = {
    autoindent = true;

    completeopt = "menu,menuone,noselect";
    cursorline = true;

    number = true;

    relativenumber = true;
    shiftwidth = 2;

    signcolumn = "yes";
    smartcase = true;

    termguicolors = true;

  };

}
