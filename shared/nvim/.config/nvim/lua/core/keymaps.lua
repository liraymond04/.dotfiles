local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

keymap("i", "<C-c>", "<Esc>", opts)

keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", opts)
keymap("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", opts)
keymap("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-j>", ":bprevious<CR>", opts)
keymap("n", "<S-k>", ":bnext<CR>", opts)

-- Reorder buffers
keymap("n", "<m-k>", ":BufferLineMoveNext<CR>", opts)
keymap("n", "<m-j>", ":BufferLineMovePrev<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<J>", ":m .+1<CR>==", opts)
keymap("v", "<K>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Comment
-- Control forward slash comes out as ^_
keymap("n", "<C-_>", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<C-_>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)
keymap("n", "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<C-/>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)
-- keymap("n", "<C-_>", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
-- keymap("x", "<C-_>", '<ESC><CMD>lua require("Comment.api").toggle.blockwise.current(vim.fn.visualmode())<CR>', opts)

-- Harpoon
vim.keymap.set("n", "m", function()
  require("harpoon.ui").nav_file(vim.v.count)
end, opts)
-- keymap("n", "m", toggle_move, opts)

-- LSP signature help
keymap("n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
-- keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("x", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

-- vim-sneak
-- keymap("n", "<C-c>", '<cmd>lua vim.fn["sneak#util#removehl"]()<CR>', opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
