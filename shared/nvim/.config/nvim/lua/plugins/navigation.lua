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
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Default mappings. Feel free to modify or remove as you wish.
        --
        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
        -- vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "bd", api.marks.bulk.delete, opts("Delete Bookmarked"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle Filter: No Buffer"))
        vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Filter: Git Clean"))
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
        vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
        vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
        vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
        -- END_DEFAULT_ON_ATTACH

        -- Mappings migrated from view.mappings.list
        --
        -- You will need to insert "your code goes here" for any mappings with a custom action_cb
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
      end,
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      renderer = {
        root_folder_modifier = ":t",
        icons = {
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_open = "",
              arrow_closed = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "S",
              unmerged = "",
              renamed = "➜",
              untracked = "U",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "󰌵",
          info = "",
          warning = "",
          error = "",
        },
      },
      view = {
        width = 30,
        side = "left",
        number = true,
        relativenumber = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "moll/vim-bbye",
    },
    opts = {
      options = {
        numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
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
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
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
