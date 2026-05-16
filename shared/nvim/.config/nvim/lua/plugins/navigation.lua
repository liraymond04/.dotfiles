-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  {
    "ThePrimeagen/harpoon",
  },
  {
    "justinmk/vim-sneak",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "mluders/comfy-line-numbers.nvim",
    opts = {},
  },
  {
    "abecodes/tabout.nvim",
    lazy = false,
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>",             -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true,            -- shift content if tab out is not possible
        act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>",        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>",  -- reverse shift default action,
        enable_backwards = true,      -- well ...
        completion = true,           -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp",
    },
    opt = true,              -- Set this to true if the plugin is optional
    event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "moll/vim-bbye",
    },
    opts = {
      options = {
        numbers = "none",                    -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "Bdelete! %d",       -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
        -- NOTE: this plugin is designed with this icon in mind,
        -- and so changing this is NOT recommended, this is intended
        -- as an escape hatch for people who cannot bear it for whatever reason
        indicator_icon = "▎",
        buffer_close_icon = "󰅖",
        -- buffer_close_icon = '',
        modified_icon = "●",
        close_icon = "",
        -- close_icon = '󰅙',
        left_trunc_marker = "",
        right_trunc_marker = "",
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
        --   -- remove extension from markdown files for example
        --   if buf.name:match('%.md') then
        --     return vim.fn.fnamemodify(buf.name, ':t:r')
        --   end
        -- end,
        max_name_length = 30,
        max_prefix_length = 30,   -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --   return "("..count..")"
        -- end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        -- custom_filter = function(buf_number)
        --   -- filter out filetypes you don't want to see
        --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        --     return true
        --   end
        --   -- filter out by buffer name
        --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        --     return true
        --   end
        --   -- filter out based on arbitrary rules
        --   -- e.g. filter out vim wiki buffer from tabline in your work repo
        --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        --     return true
        --   end
        -- end,
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        --   -- add custom logic
        --   return buffer_a.modified > buffer_b.modified
        -- end
      },
      highlights = {
        fill = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        background = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },

        buffer_selected = {
          guifg = { attribute = "fg", highlight = "Normal" },
          guibg = { attribute = "bg", highlight = "Normal" },
          gui = "none",
        },
        buffer_visible = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },

        close_button = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        close_button_visible = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        -- close_button_selected = {
        --   guifg = {attribute='fg',highlight='TabLineSel'},
        --   guibg ={attribute='bg',highlight='TabLineSel'}
        --   },

        tab_selected = {
          guifg = { attribute = "fg", highlight = "Normal" },
          guibg = { attribute = "bg", highlight = "Normal" },
        },
        tab = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        tab_close = {
          -- guifg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
          guifg = { attribute = "fg", highlight = "TabLineSel" },
          guibg = { attribute = "bg", highlight = "Normal" },
        },

        duplicate_selected = {
          guifg = { attribute = "fg", highlight = "TabLineSel" },
          guibg = { attribute = "bg", highlight = "TabLineSel" },
          gui = "italic",
        },
        duplicate_visible = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
          gui = "italic",
        },
        duplicate = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
          gui = "italic",
        },

        modified = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        modified_selected = {
          guifg = { attribute = "fg", highlight = "Normal" },
          guibg = { attribute = "bg", highlight = "Normal" },
        },
        modified_visible = {
          guifg = { attribute = "fg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },

        separator = {
          guifg = { attribute = "bg", highlight = "TabLine" },
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        separator_selected = {
          guifg = { attribute = "bg", highlight = "Normal" },
          guibg = { attribute = "bg", highlight = "Normal" },
        },
        -- separator_visible = {
        --   guifg = {attribute='bg',highlight='TabLine'},
        --   guibg = {attribute='bg',highlight='TabLine'}
        --   },
        indicator_selected = {
          guifg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
          guibg = { attribute = "bg", highlight = "Normal" },
        },

        error = {
          guifg = "#9D4B52",
          guibg = { attribute = "bg", highlight = "TabLine" },
          gui = "none",
        },
        -- error_visible = {
        --   guifg = '<color-value-here>',
        --   guibg = '<color-value-here>'
        -- },
        error_selected = {
          -- guifg = '<color-value-here>',
          -- guibg = '<color-value-here>',
          gui = "none",
          -- guisp = '<color-value-here>',
        },
        error_diagnostic = {
          guifg = "#9D4B52",
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        -- error_diagnostic_visible = {
        --   guifg = '<color-value-here>',
        --   guibg = '<color-value-here>',
        -- },
        error_diagnostic_selected = {
          guifg = "#E06C75",
          -- guibg = '<color-value-here>',
          gui = "none",
          -- guisp = '<color-value-here>'
        },

        warning = {
          guifg = "#A18756",
          guibg = { attribute = "bg", highlight = "TabLine" },
          gui = "none",
          -- guisp = '<color-value-here>',
        },
        -- warning_visible = {
        --   guifg = '<color-value-here>',
        --   guibg = '<color-value-here>'
        -- },
        warning_selected = {
          -- guifg = '<color-value-here>',
          -- guibg = '<color-value-here>',
          gui = "none",
          -- guisp = '<color-value-here>'
        },
        warning_diagnostic = {
          guifg = "#A18756",
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        -- warning_diagnostic_visible = {
        --   guifg = '<color-value-here>',
        --   guibg = '<color-value-here>'
        -- },
        warning_diagnostic_selected = {
          guifg = "#E5C07B",
          -- guibg = '<color-value-here>',
          gui = "none",
          -- guisp = '<color-value-here>'
        },

        info = {
          guifg = "#447BA8",
          guibg = { attribute = "bg", highlight = "TabLine" },
          gui = "none",
          -- guisp = '<color-value-here>',
        },
        -- info_visible = {
        --   guifg = '<color-value-here>',
        --   guibg = '<color-value-here>'
        -- },
        info_selected = {
          -- guifg = '<color-value-here>',
          -- guibg = '<color-value-here>',
          gui = "none",
          -- guisp = '<color-value-here>'
        },
        info_diagnostic = {
          guifg = "#447BA8",
          guibg = { attribute = "bg", highlight = "TabLine" },
        },
        -- info_diagnostic_visible = {
        --   guifg = '<color-value-here>',
        --   guibg = '<color-value-here>'
        -- },
        info_diagnostic_selected = {
          guifg = "#61AFEF",
          -- guibg = '<color-value-here>',
          gui = "none",
          -- guisp = '<color-value-here>'
        },
      },
    },
  },
}
