call plug#begin('~/.config/nvim/plugged')

"Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
"Plug 'mengelbrecht/lightline-bufferline'
Plug 'andymass/vim-matchup'
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Semantic language support
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Completion framework
Plug 'hrsh7th/nvim-cmp'
" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'
" Other useful completion sources
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Snippet engine
Plug 'hrsh7th/vim-vsnip'
" To enable more of the features of rust-analyzer, such as inlay hints and more!
" Plug 'simrat39/rust-tools.nvim'

call plug#end()

" Load Lua config
" Alternative is to move init.lua into base directory, but cannot control load
" order after plugins
lua require('jiraffe7')

let mapleader=" "

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Window mappings
nnoremap <leader>o :split<CR>
nnoremap <leader>e :vsplit<CR>
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
set splitright
set splitbelow

" Move from the yank register to the unnamed register
" so that paste from yank after deleting
nnoremap <leader>p :let @"=@0<CR>

" Copy paste mappings
vnoremap <leader>c "+y
vnoremap <leader>v "+p
nnoremap <leader>v "+p

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

let NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>N :NERDTreeFind<CR>

let $FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git'"

nnoremap <leader>g :RG<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ],
      \ }
      \ }

" lightline-bufferline settings
"let g:lightline#bufferline#show_number  = 1
"let g:lightline#bufferline#shorten_path = 0
"let g:lightline#bufferline#unnamed      = '[No Name]'
"
"let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
"let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
"let g:lightline.component_type   = {'buffers': 'tabsel'}
"set showtabline=2

" vim-gitgutter settings
" disable all key mappings
let g:gitgutter_map_keys = 0

set relativenumber
set number

set noexpandtab
set shiftwidth=8
set softtabstop=8
set tabstop=8
set smartindent

set ignorecase
set smartcase

set termguicolors
set background=dark
let base16colorspace=256
let g:base16_shell_path="~/.config/nvim/colors"
colorscheme base16-gruvbox-dark-hard

highlight clear SignColumn

au TextYankPost * silent! lua vim.highlight.on_yank {timeout=1500}


" copied from github.com/jonhoo/configs

" Quick-save
nmap <leader>w :w<CR>

set scrolloff=2
"let g:sneak#s_next = 1
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

set colorcolumn=120,240

" Decent wildmenu
set wildmenu
set wildmode=list:longest

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Back and Forward centered please
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz

set mouse=a " Enable mouse usage (all modes) in terminals

" ; as :
nnoremap ; :
" map <C-;> since ; is mapped to :
" map <C-,> for symmetry
nnoremap <C-;> ;
nnoremap <C-,> ,

" Ctrl+j and Ctrl+k as Esc
nnoremap <C-j> <Esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <C-c>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>
"
" Ctrl+/ to stop searching
vnoremap <C-/> :nohlsearch<cr>
nnoremap <C-/> :nohlsearch<cr>

" Jump to start and end of line using the home row keys
map H ^
map L $

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" Permanent undo
set undodir=~/.local/share/nvim/undo//
set undofile

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>

" No arrow keys --- force yourself to use the home row
"nnoremap <up> <nop>
"nnoremap <down> <nop>
" Up and down can switch windows
nnoremap <up> <C-w>W
nnoremap <down> <C-w>w
" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" autocmd

" rust format on save
autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async=false })

" go format on save
autocmd BufWritePre *.go lua vim.lsp.buf.format({ async=false })
" go format imports on save
autocmd BufWritePre *.go lua require('jiraffe7.go').goimports(1000)

" python run command with S-F10 which maps to F22
autocmd FileType python map <buffer> <F22> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F22> <esc>:w<CR>:exec '!python' shellescape(@%, 1)<CR>

" terraform filetype
autocmd BufRead *.tf set filetype=terraform
autocmd Filetype terraform set shiftwidth=2 softtabstop=2 tabstop=2 expandtab autoindent
