return {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      local opts = {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right | horizontal | vertical
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          trigger_on_accept = true,
          keymap = {
            accept = "<D-l>",
            accept_word = false,
            accept_line = false,
            next = "<D-]>",
            prev = "<D-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        auth_provider_url = nil,       -- URL to authentication provider, if not "https://github.com/"
        copilot_node_command = "node", -- Node.js version must be > 20
        workspace_folders = {},
        copilot_model = "",
        root_dir = function()
          return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
        end,
        server = {
          type = "nodejs", -- "nodejs" | "binary"
          custom_server_filepath = nil,
        },
        server_opts_overrides = {},
      }

      if vim.g.copilot_enabled then
        require("copilot").setup(opts)
      end

      vim.api.nvim_create_user_command("CopilotToggle", function()
        if vim.g.copilot_enabled == false then
          require("copilot").setup(opts)
          vim.g.copilot_enabled = true
        else
          if require("copilot.client").is_disabled() then
            require("copilot.command").enable()
          else
            require("copilot.command").disable()
          end
        end
      end, { desc = "Toggle Copilot" })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "copilot",
      mode = "legacy",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
