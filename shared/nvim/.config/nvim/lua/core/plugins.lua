-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Hey! Put lazy into the runtimepath for neovim!
vim.opt.runtimepath:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "navarasu/onedark.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        local theme = require("onedark")
        theme.setup({
          transparent = true,
        })
        theme.load()
        vim.api.nvim_set_hl(0, "IndentLine", { fg = "#5c6370" })
        -- vim.api.nvim_set_hl(0, "IndentLineCurrent", { bold = true })
      end,
    },
    { import = "plugins" },
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
})
