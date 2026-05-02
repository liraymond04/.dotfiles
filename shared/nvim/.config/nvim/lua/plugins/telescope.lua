return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "ahmedkhalf/project.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local state = require("telescope.state")
      local action_state = require("telescope.actions.state")
      local actions = require("telescope.actions")

      local slow_scroll = function(prompt_bufnr, direction)
        local previewer = action_state.get_current_picker(prompt_bufnr).previewer
        local status = state.get_status(prompt_bufnr)

        -- Check if we actually have a previewer and a preview window
        if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
          return
        end

        previewer:scroll_fn(1 * direction)
      end

      require("telescope").setup({
        defaults = {

          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },

          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-c>"] = actions.close,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<C-e>"] = function(bufnr)
                slow_scroll(bufnr, 1)
              end,
              ["<C-y>"] = function(bufnr)
                slow_scroll(bufnr, -1)
              end,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
            find_command = {
              "rg",
              "--files",
              "--hidden",

              -- Exclude some patterns from search
              "--glob=!**/.git/*",
              "--glob=!**/.idea/*",
              "--glob=!**/.vscode/*",
              "--glob=!**/build/*",
              "--glob=!**/dist/*",
              "--glob=!**/yarn.lock",
              "--glob=!**/bun.lock",
              "--glob=!**/package-lock.json",
              "--glob=!**/Cargo.lock",
            },
          },
          vimgrep_arguments = {
            "rg",
            "--follow",        -- Follow symbolic links
            "--hidden",        -- Search for hidden files
            "--no-heading",    -- Don't group matches by each file
            "--with-filename", -- Print the file path with the matched lines
            "--line-number",   -- Show line numbers
            "--column",        -- Show column numbers
            "--smart-case",    -- Smart case search

            -- Exclude some patterns from search
            "--glob=!**/.git/*",
            "--glob=!**/.idea/*",
            "--glob=!**/.vscode/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/yarn.lock",
            "--glob=!**/bun.lock",
            "--glob=!**/package-lock.json",
            "--glob=!**/Cargo.lock",
          },
          -- live_grep = {
          --   additional_args = function(opts)
          --     return { "--hidden" }
          --   end,
          -- },
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
      })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("projects")
      require("telescope").load_extension("ui-select")

      --   vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags)
      --   vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files)
      --   vim.keymap.set("n", "<leader>fg", require('telescope.builtin').live_grep)
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        ---@usage set to false to disable project.nvim.
        --- This is on by default since it's currently the expected behavior.
        active = true,

        on_config_done = nil,

        ---@usage set to true to disable setting the current-woriking directory
        --- Manual mode doesn't automatically change your root directory, so you have
        --- the option to manually do so using `:ProjectRoot` command.
        manual_mode = false,

        ---@usage Methods of detecting the root directory
        --- Allowed values: **"lsp"** uses the native neovim lsp
        --- **"pattern"** uses vim-rooter like glob pattern matching. Here
        --- order matters: if one is not detected, the other is used as fallback. You
        --- can also delete or rearangne the detection methods.
        -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
        detection_methods = { "pattern" },

        ---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

        ---@ Show hidden files in telescope when searching for files in a project
        show_hidden = false,

        ---@usage When set to false, you will get a message when project.nvim changes your directory.
        -- When set to false, you will get a message when project.nvim changes your directory.
        silent_chdir = true,

        ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
        ignore_lsp = {},

        ---@type string
        ---@usage path to store the project history for use in telescope
        datapath = vim.fn.stdpath("data"),
      })

      require("telescope").load_extension("projects")
    end,
  },
}
