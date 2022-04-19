"Plugins
"Reload init.vim with :source $MYVIMRC
"Update plugins with :PlugInstall
call plug#begin()

Plug 'jdhao/better-escape.vim'
Plug 'vim-airline/vim-airline'

Plug 'https://github.com/joshdick/onedark.vim.git'

Plug 'jiangmiao/auto-pairs'
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-obsession'
Plug 'preservim/nerdtree'

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


"Coc options
"Add clangd lsp with :CocInstall coc-clangd
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


"Nerdtree options
nnoremap <leader>f :NERDTreeFocus<CR>
nnoremap <leader>n :NERDTree<CR>
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>F :NERDTreeFind<CR>
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber


"Mouse scroll options
nmap<Down> <C-e>
nmap<Up> <C-y>


let g:better_escape_shortcut = 'kj'
