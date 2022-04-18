"Plugins
call plug#begin()

Plug 'jdhao/better-escape.vim'
Plug 'vim-airline/vim-airline'

Plug 'https://github.com/joshdick/onedark.vim.git'

Plug 'jiangmiao/auto-pairs'
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-obsession'

call plug#end()


"Set truecolour
set termguicolors


"Options
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif
syntax on
colorscheme onedark
let g:airline_theme='onedark'

set number relativenumber

set tabstop=4
set shiftwidth=4
set expandtab

let g:better_escape_shortcut = 'kj'

"Coc options
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
