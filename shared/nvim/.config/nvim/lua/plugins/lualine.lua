local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  right_padding = 2,
}

local filetype = {
  "filetype",
  icons_enabled = true,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local percent_progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  if current_line == 1 then
    return "TOP"
  elseif current_line == total_lines then
    return "BOT"
  end
  local line_ratio = current_line / total_lines * 100
  local percent_string = tostring(math.floor(line_ratio + 0.5))
  local prefix = string.rep(" ", 2 - percent_string:len())
  return prefix .. percent_string .. "%%"
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { "filename" },
        lualine_c = { branch, diagnostics },
        -- lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_x = { diff, spaces, "encoding", filetype },
        lualine_y = { location },
        lualine_z = { percent_progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    },
  },
}
