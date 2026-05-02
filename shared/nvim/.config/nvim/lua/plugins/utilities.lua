return {
  {
    "lambdalisue/vim-suda",
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})

      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(
            function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end
          ),
      })
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules({
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_)
              return "<C-c>2xi<CR><C-c>O"
            end),
        })
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
  },
  {
    "arch1t3cht/ass.nvim",
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-t>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = "zsh",
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      ---@diagnostic disable-next-line: duplicate-set-field
      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(0, "t", "<esc>", "<cmd>close<CR>", { silent = false, noremap = true })
          if vim.fn.mapcheck("<esc>", "t") ~= "" then
            vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
          end
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      local node = Terminal:new({ cmd = "node", hidden = true })

      function _NODE_TOGGLE()
        node:toggle()
      end

      local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

      function _NCDU_TOGGLE()
        ncdu:toggle()
      end

      local htop = Terminal:new({ cmd = "htop", hidden = true })

      function _HTOP_TOGGLE()
        htop:toggle()
      end

      local python = Terminal:new({ cmd = "python", hidden = true })

      function _PYTHON_TOGGLE()
        python:toggle()
      end
    end,
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        auto_load = true, -- whether to automatically load preview when
        -- entering another markdown buffer
        close_on_bdelete = true, -- close preview window on buffer delete

        syntax = true, -- enable syntax highlighting, affects performance

        theme = "dark", -- 'dark' or 'light'

        update_on_change = true,

        -- app = { 'firefox', '--new-window' }, -- 'webview', 'browser', string or a table of strings
        app = "webview",
        -- explained below

        filetype = { "markdown" }, -- list of filetypes to recognize as markdown

        -- relevant if update_on_change is true
        throttle_at = 200000, -- start throttling when file exceeds this
        -- amount of bytes in size
        throttle_time = "auto", -- minimum amount of time in milliseconds
        -- that has to pass before starting new render
      })
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "pteroctopus/faster.nvim",
    opts = {
      -- Behaviour table contains configuration for behaviours faster.nvim uses
      behaviours = {
        -- Bigfile configuration controls disabling and enabling of features when
        -- big file is opened
        bigfile = {
          -- Behaviour can be turned on or off. To turn on set to true, otherwise
          -- set to false
          on = true,
          -- Table which contains names of features that will be disabled when
          -- bigfile is opened. Feature names can be seen in features table below.
          -- features_disabled can also be set to "all" and then all features that
          -- are on (on=true) are going to be disabled for this behaviour
          features_disabled = {
            "illuminate",
            "matchparen",
            "lsp",
            "treesitter",
            "indent_blankline",
            "vimopts",
            "syntax",
            "filetype",
          },
          -- Files larger than `filesize` are considered big files. Value is in MB.
          filesize = 2,
          -- Autocmd pattern that controls on which files behaviour will be applied.
          -- `*` means any file.
          pattern = "*",
          -- Optional extra patterns and sizes for which bigfile behaviour will apply.
          -- Note! that when multiple patterns (including the main one) and filesizes
          -- are defined: bigfile behaviour will be applied for minimum filesize of
          -- those defined in all applicable patterns for that file.
          -- extra_pattern example in multi line comment is bellow:
          --[[
            extra_patterns = {
              -- If this is used than bigfile behaviour for *.md files will be
              -- triggered for filesize of 1.1MiB
              { filesize = 1.1, pattern = "*.md" },
              -- If this is used than bigfile behaviour for *.log file will be
              -- triggered for the value in `behaviours.bigfile.filesize`
              { pattern  = "*.log" },
              -- Next line is invalid without the pattern and will be ignored
              { filesize = 3 },
            },
            ]]
          -- By default `extra_patterns` is an empty table: {}.
          extra_patterns = {},
        },
        -- Fast macro configuration controls disabling and enabling features when
        -- macro is executed
        fastmacro = {
          -- Behaviour can be turned on or off. To turn on set to true, otherwise
          -- set to false
          on = true,
          -- Table which contains names of features that will be disabled when
          -- macro is executed. Feature names can be seen in features table below.
          -- features_disabled can also be set to "all" and then all features that
          -- are on (on=true) are going to be disabled for this behaviour.
          -- Specificaly: lualine plugin is disabled when macros are executed because
          -- if a recursive macro opens a buffer on every iteration this error will
          -- happen after 300-400 hundred iterations:
          -- `E5108: Error executing lua Vim:E903: Process failed to start: too many open files: "/usr/bin/git"`
          features_disabled = { "lualine" },
        },
      },
      -- Feature table contains configuration for features faster.nvim will disable
      -- and enable according to rules defined in behaviours.
      -- Defined feature will be used by faster.nvim only if it is on (`on=true`).
      -- Defer will be used if some features need to be disabled after others.
      -- defer=false features will be disabled first and defer=true features last.
      features = {
        -- Neovim filetype plugin
        -- https://neovim.io/doc/user/filetype.html
        filetype = {
          on = true,
          defer = true,
        },
        -- Illuminate plugin
        -- https://github.com/RRethy/vim-illuminate
        illuminate = {
          on = true,
          defer = false,
        },
        -- Indent Blankline
        -- https://github.com/lukas-reineke/indent-blankline.nvim
        indent_blankline = {
          on = true,
          defer = false,
        },
        -- Neovim LSP
        -- https://neovim.io/doc/user/lsp.html
        lsp = {
          on = true,
          defer = false,
        },
        -- Lualine
        -- https://github.com/nvim-lualine/lualine.nvim
        lualine = {
          on = true,
          defer = false,
        },
        -- Neovim Pi_paren plugin
        -- https://neovim.io/doc/user/pi_paren.html
        matchparen = {
          on = true,
          defer = false,
        },
        -- Neovim syntax
        -- https://neovim.io/doc/user/syntax.html
        syntax = {
          on = true,
          defer = true,
        },
        -- Neovim treesitter
        -- https://neovim.io/doc/user/treesitter.html
        treesitter = {
          on = true,
          defer = false,
        },
        -- Neovim options that affect speed when big file is opened:
        -- swapfile, foldmethod, undolevels, undoreload, list
        vimopts = {
          on = true,
          defer = false,
        },
      },
    },
  },
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "main", to use the latest commit
    opts = {
      win_opts = {
        row = 6,
      },
    },
  },
  {
    "nyngwang/NeoZoom.lua",
    config = function()
      require("neo-zoom").setup({
        popup = { enabled = true }, -- this is the default.
        -- NOTE: Add popup-effect (replace the window on-zoom with a `[No Name]`).
        -- EXPLAIN: This improves the performance, and you won't see two
        --          identical buffers got updated at the same time.
        -- popup = {
        --   enabled = true,
        --   exclude_filetypes = {},
        --   exclude_buftypes = {},
        -- },
        exclude_buftypes = { "terminal" },
        -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
        winopts = {
          offset = {
            -- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
            -- top = 0,
            -- left = 0.17,
            width = 150,
            height = 0.85,
          },
          -- NOTE: check :help nvim_open_win() for possible border values.
          border = "thicc", -- this is a preset, try it :)
        },
        presets = {
          {
            -- NOTE: regex pattern can be used here!
            filetypes = { "dapui_.*", "dap-repl" },
            winopts = {
              offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
            },
          },
          {
            filetypes = { "markdown" },
            callbacks = {
              function()
                vim.wo.wrap = true
              end,
            },
          },
        },
      })
    end,
  },
}
