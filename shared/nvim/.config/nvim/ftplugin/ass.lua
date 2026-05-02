vim.opt_local.wrap = false
vim.opt_local.comments = ":;"
vim.opt_local.commentstring = ";%s"

local function open_ass_editor()
  local curbufnr = vim.api.nvim_get_current_buf()
  local curwin = vim.api.nvim_get_current_win()

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  if not line:match("^Dialogue:") then
    vim.notify("Not an ASS Dialogue line", vim.log.levels.WARN)
    return
  end

  -- Extract text field (after 9th comma)
  local prefix, text = line:match("^(Dialogue:[^,]-,[^,]-,[^,]-,[^,]-,[^,]-,[^,]-,[^,]-,[^,]-,[^,]-,)(.*)$")
  if not prefix or not text then
    vim.notify("Unable to parse line", vim.log.levels.ERROR)
    return
  end

  -- Create temporary buffer
  local filename = vim.fn.tempname()
  local bufnr = vim.fn.bufadd(filename)

  -- make like scratch buffer
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false

  local win_width = math.floor(vim.o.columns * 0.6)
  local win_height = 6
  local win_row = math.floor((vim.o.lines - win_height) / 2)
  local win_col = math.floor((vim.o.columns - win_width) / 2)

  local _ = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = win_row,
    col = win_col,
    style = "minimal",
    border = "rounded",
  })

  -- Write placeholder title (original text) as virtual line using extmark
  local ns = vim.api.nvim_create_namespace("ass-float-editor")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" }) -- Start with a single empty line
  vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 0, {
    virt_lines = { { { "Original: " .. text, "Comment" } } },
    virt_lines_above = true,
    hl_mode = "combine",
  })

  -- Move cursor to line 1
  -- vim.api.nvim_win_set_cursor(win, { 1, 0 })

  -- On save
  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = bufnr,
    once = true,
    callback = function()
      local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local new_text = table.concat(new_lines, " ")
      new_text = vim.trim(new_text)
      if new_text == "" then
        vim.api.nvim_buf_delete(bufnr, { force = true })
        return
      end

      -- Update the main buffer
      -- Move the original text into a Comment: line
      local comment_line = prefix:gsub("^Dialogue:", "Comment:") .. text
      vim.api.nvim_buf_set_lines(curbufnr, row - 1, row - 1, false, { comment_line })

      -- Replace the dialogue line with the new text
      local new_line = prefix .. new_text
      vim.api.nvim_buf_set_lines(curbufnr, row, row + 1, false, {
        new_line,
      })

      vim.api.nvim_win_set_cursor(curwin, {row + 1, col})

      -- cleanup
      vim.loop.fs_unlink(filename)
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end,
  })

  -- Auto-close if not saved
  vim.api.nvim_create_autocmd({ "BufLeave", "BufUnload" }, {
    buffer = bufnr,
    callback = function()
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end,
  })
end

-- Map it
vim.keymap.set("n", "<leader>/", open_ass_editor, {
  noremap = true,
  silent = true,
  desc = "Edit .ass dialogue in floating window",
})

-- TODO
-- Scratchpad above with the original text, instead of virtual text (try and read if there's a comment above)
-- (optional), machine translation preview
-- dictionary search, by default search entire original text string
-- but also, narrow down dictionary search to words under the cursor highlight
-- show terms in a prevew window either above or to the sides (config)
-- use ctrl j k to scroll up and down the terms (kinda like telescope window, reference that)
-- use enter to confirm translation (maybe)
-- if we know that we have already inputted a translation (basically, if we know that above has the original text string)
-- we're "editing" an existing translation, so we should be adding that text to our edit buffer, and then when we save
-- we just replace (and of course, the original text preview should show the original text in the comment string



-- function add_comment_above()
--     local line = vim.api.nvim_get_current_line()
--     -- Check if the line starts with "Dialogue:"
--     if not line:find("^Dialogue:") then
--         return
--     end
--     -- Split into event type and the rest of the line
--     local event_type, rest = line:match("^(Dialogue:%s*)(.*)$")
--     if not event_type or not rest then
--         return
--     end
--     -- Extract fields and text (handling commas in text)
--     local fields = {}
--     local text = rest
--     for i = 1, 9 do
--         local pos = text:find(",")
--         if not pos then
--             return -- Invalid format, exit
--         end
--         fields[i] = text:sub(1, pos - 1)
--         text = text:sub(pos + 1)
--     end
--     -- Construct the Comment line
--     local comment_line = "Comment: " .. table.concat(fields, ",") .. "," .. text
--     -- Insert the comment line above the current line
--     local row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Zero-based row
--     vim.api.nvim_buf_set_lines(0, row, row, false, { comment_line })
-- end
-- vim.api.nvim_set_keymap('n', '<leader>.', '<cmd>lua add_comment_above()<CR>', {
--     noremap = true,
--     silent = true,
-- })
