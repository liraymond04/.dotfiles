return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      local formatting = null_ls.builtins.formatting

      local sources = {
        formatting.stylua,
        -- formatting.eslint_d,
        -- formatting.clang_format,
      }

      null_ls.setup({
        debug = false,
        sources = sources,
        -- on_attach = on_attach
      })
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>;;",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "saghen/blink.cmp",
        -- dependencies = { "rafamadriz/friendly-snippets" },

        version = "1.*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          keymap = {
            preset = "default",
            ["<C-k>"] = { "select_prev" },
            ["<C-j>"] = { "select_next" },
            ["<C-,>"] = { "show" },
            ["<C-s>"] = { "show_signature" },
            ["<Tab>"] = {
              function(cmp)
                if cmp.is_visible() then
                  return cmp.accept({
                    callback = function()
                      cmp.show_signature()
                    end,
                  })
                end
              end,
              "fallback",
            },
          },

          appearance = {
            nerd_font_variant = "mono",
          },

          completion = {
            documentation = {
              auto_show = true,
              auto_show_delay_ms = 0,
              window = {
                border = "rounded",
                min_width = 60,
              },
            },
          },

          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
          },

          fuzzy = { implementation = "prefer_rust_with_warning" },

          signature = {
            enabled = true,
            window = {
              show_documentation = true,
              border = "rounded",
              min_width = 60,
            },
          },
        },
        opts_extend = { "sources.default" },
      },
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              normal_hl = "FidgetWindow",
              winblend = 0,
            },
          },
        },
      },
    },
    config = function()
      -- local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- require("lspconfig").lua_ls.setup({ capabilites = capabilities })
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities() --or whatever your setup requires
      lsp_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      -- fix svelte lsp dynamic watcher
      -- require("lspconfig").svelte.setup({
      --   capabilities = lsp_capabilities,
      -- })

      local icons = require("utils.icons")

      local signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
      }

      vim.diagnostic.config({
        virtual_text = true,
        signs = signs,

        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          header = "",
          prefix = "",
          -- width = 40,
        },
      })

      vim.api.nvim_set_hl(0, "IlluminatedWordText", { blend = 100, underline = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { blend = 100, underline = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { blend = 100, underline = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then
            return
          end

          local function buf_map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc, noremap = true, silent = true })
          end

          buf_map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          buf_map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          buf_map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          buf_map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
          buf_map("n", "gr", vim.lsp.buf.references, "List references")
          buf_map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
          buf_map("n", "gK", function()
            vim.lsp.buf.hover({ border = "rounded", width = 60 })
          end, "Hover documentation")
          buf_map("n", "gl", function()
            vim.diagnostic.open_float({ border = "rounded", width = 60 })
          end, "Show diagnostics")

          -- Diagnostic navigation
          buf_map("n", "[g", function()
            vim.diagnostic.jump({ count = -1, float = true, border = "rounded" })
          end, "Previous diagnostic")
          buf_map("n", "]g", function()
            vim.diagnostic.jump({ count = 1, float = true, border = "rounded" })
          end, "Next diagnostic")
          buf_map("n", "[G", function()
            vim.diagnostic.jump({
              count = -1,
              severity = vim.diagnostic.severity.ERROR,
              float = true,
              border = "rounded",
            })
          end, "Previous error")
          buf_map("n", "]G", function()
            vim.diagnostic.jump({
              count = 1,
              severity = vim.diagnostic.severity.ERROR,
              float = true,
              border = "rounded",
            })
          end, "Next error")

          -- if vim.bo.filetype == "lua" then
          --   -- Format the current buffer on save
          --   vim.api.nvim_create_autocmd("BufWritePre", {
          --     buffer = args.buf,
          --     callback = function()
          --       vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
          --     end,
          --   })
          -- end
        end,
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "cssls",
        "cssmodules_ls",
        "emmet_ls",
        "html",
        "eslint",
        "jsonls",
        "lua_ls",
        "ts_ls",
        "svelte",
        "pyright",
        "yamlls",
        "bashls",
        "clangd",
        "cmake",
        "rust_analyzer",
        "tailwindcss",
        "texlab",
        "r_language_server",
        "marksman",
        "ocamllsp",
        "taplo",
        "yamlls",
        "gopls",
        "dockerls",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "RRethy/vim-illuminate",
  },
  {
    -- "liraymond04/awa5_rs.nvim",
    dir = "~/Documents/Programming/nvim/awa5_rs.nvim",
    opts = {},
  },
}
