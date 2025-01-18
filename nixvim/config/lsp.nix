{ pkgs, ... }:
{
  plugins.luasnip.enable = true;
  plugins.lspkind.enable = true;
  plugins.cmp = {
    enable = true;

    settings = {
      snippet = {
        expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };
      mapping = {
        __raw = ''
          cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          })
        '';
      };
      window = {
        completion = {
          __raw = ''
            cmp.config.window.bordered()
          '';
        };
        documentation = {
          __raw = ''
            cmp.config.window.bordered()
          '';
        };
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
  };

  plugins.navic = {
    enable = true;
    settings.lsp.auto_attach = true;
  };

  plugins.lsp = {
    enable = true;
    capabilities = ''
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
    '';
    servers = {
      ts_ls = {
        enable = true;
        filetypes = [
          "typescript"
          "typescriptreact"
          "typescript.tsx"
        ];
        cmd = [
          "typescript-language-server"
          "--stdio"
        ];
      };

      gopls = {
        enable = true;
        filetypes = [
          "go"
          "gomod"
          "gowork"
          "gotmpl"
        ];
        cmd = [ "gopls" ];
        rootDir = ''require("lspconfig").util.root_pattern("go.work", "go.mod", ".git")'';
        settings = {
          gopls = {
            gofumpt = true;
            codelenses = {
              gc_details = false;
              generate = true;
              regenerate_cgo = true;
              run_govulncheck = true;
              test = true;
              tidy = true;
              upgrade_dependency = true;
              vendor = true;
            };
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
            analyses = {
              fieldalignment = true;
              nilness = true;
              unusedparams = true;
              unusedwrite = true;
              useany = true;
            };
            usePlaceholders = true;
            completeUnimported = true;
            staticcheck = true;
            semanticTokens = true;
          };
        };
      };

      lua_ls = {
        enable = true;
        filetypes = [ "lua" ];
        cmd = [ "lua-language-server" ];
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT";
            };
            diagnostics = {
              globals = [ "vim" ];
            };
            workspace = {
              library = ''vim.api.nvim_get_runtime_file("", true)'';
              checkThirdParty = false;
            };
            telemetry = {
              enable = false;
            };
          };
        };
      };

      nixd = {
        enable = true;
        filetypes = [ "nix" ];
        cmd = [ "nixd" ];
        rootDir = "require('lspconfig.util').root_pattern('flake.nix', '.git')";
        settings = {
          nixpkgs = {
            expr = "import <nixpkgs> { }";
          };
          formatting = {
            command = [ "nixfmt" ];
          };
        };
      };

      tailwindcss = {
        enable = true;
      };

      pyright = {
        enable = true;
      };
      ruff = {
        enable = true;
      };
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    barbecue-nvim

    (pkgs.vimUtils.buildVimPlugin {
      name = "none-ls-extras.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "nvimtools";
        repo = "none-ls-extras.nvim";
        rev = "6557f20e631d2e9b2a9fd27a5c045d701a3a292c";
        hash = "sha256-cd7HJLfLbVs7v+eE+8JrDc0nj/DOGVTbwNEMdZsf2qk=";
      };
      dependencies = with pkgs.vimPlugins; [ none-ls-nvim ];
    })
  ];

  extraConfigLua = ''
        local null_ls = require("null-ls")
        local builtins = null_ls.builtins
        local code_actions = builtins.code_actions


        null_ls.setup({
          sources = {
            require("none-ls.formatting.rustfmt"),
            require("none-ls.formatting.ruff_format"),
            require("none-ls.diagnostics.ruff"),
            require("none-ls.diagnostics.eslint_d"),
            require("none-ls.code_actions.eslint_d"),
            builtins.formatting.nixfmt,
            builtins.formatting.gofmt,
            code_actions.refactoring,
            code_actions.gomodifytags,
            code_actions.impl,
            builtins.formatting.stylua,
            builtins.formatting.prettierd,
            builtins.diagnostics.luacheck,
          },
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show hover documentation" })
            -- Enable formatting on sync
            if client.supports_method("textDocument/formatting") then
              local format_on_save = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
              vim.api.nvim_create_autocmd('BufWritePre', {
                group = format_on_save,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({
                    bufnr = bufnr,
                    filter = function(_client)
                      return _client.name == "null-ls"
                    end
                  })
                end,
              })
            end

          end,
        })
          -- triggers CursorHold event faster
          vim.opt.updatetime = 200

          require("barbecue").setup({
            create_autocmd = false, -- prevent barbecue from updating itself automatically
          })

          vim.api.nvim_create_autocmd({
            "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
    	"BufWinEnter",
            "CursorHold",
            "InsertLeave",

            -- include this if you have set `show_modified` to `true`
            "BufModifiedSet",
          }, {
            group = vim.api.nvim_create_augroup("barbecue.updater", {}),
            callback = function()
              require("barbecue.ui").update()
            end,
          })

  '';
}
