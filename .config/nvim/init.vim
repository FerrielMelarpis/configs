set shell=/usr/bin/zsh
let mapleader = '\'

" ===========
" PLUGINS
" ===========
set nocompatible
filetype off

call plug#begin()

" Vim enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

" Colorschemes
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale' 
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'airblade/vim-gitgutter'

Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'

" Completion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-syntax'
Plug 'Shougo/neco-syntax' " ncm2-syntax dep
Plug 'Shougo/neco-vim'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-cssomni' "css
Plug 'ncm2/ncm2-go' " go
Plug 'ncm2/ncm2-tern' " javascript
Plug 'HerringtonDarkholme/yats.vim' " nvim-typescript dep
Plug 'mhartington/nvim-typescript', { 'do': './install.sh' } " typescript
Plug 'ncm2/ncm2-jedi' " python
Plug 'ncm2/ncm2-vim' " vimscript
Plug 'phpactor/ncm2-phpactor' " php

" Language Server Integration
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh'
            \ }

" Syntactic language support
Plug 'rust-lang/rust.vim'
Plug 'posva/vim-vue'

call plug#end()

if !has('gui_running')
    set t_Co=256
endif

set background=dark
colorscheme nord
hi Normal ctermbg=NONE

syntax on

" use ripgrep
if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" quick save
nmap <leader>w :w<CR>

" ===============
" Plugin settings
" ===============

" ale configuration
let g:ale_linters = { 'rust': [ 'rls' ] }
let g:ale_rust_cargo_use_clippy = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_virtualtext_cursor = 1
let g:ale_rust_rls_config = {
            \ 'rust': {
            \ 'all_targets': 1,
            \ 'build_on_save': 1,
            \ 'clippy_preference': 'on'
            \ }
            \}
highlight link ALEWarningSign Todo
highlight link ALEErrorSign WarningMsg
highlight link ALEVirtualTextWarning Todo
highlight link ALEVirtualTextInfo Todo
highlight link ALEVirtualTextError WarningMsg
highlight ALEError guibg=None
highlight ALEWarning guibg=None
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "i"
let g:ale_sign_hint = "➤"
let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {
            \ '\.min\.*$': {'ale_linters': [], 'ale_fixers': []}
            \}
set cmdheight=2

nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>

" rust.vim configuration
let g:rustfmt_autosave = 1
" :RustPlay command will send the current selection to Rust playpen
let g:rust_clip_command = 'xclip -selection clipboard'
let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

" ncm2 configuration
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
set shortmess+=c
inoremap <c-c> <ESC>
" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.<Paste>
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Use <Tab> to select the popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Add 180ms delay before the omni wrapper:
au User Ncm2Plugin call ncm2#register_source({
            \ 'name': 'css',
            \ 'priority': 9,
            \ 'subscope_enable': 1,
            \ 'scope': ['css', 'scss'],
            \ 'mark': 'css',
            \ 'word_pattern': '[\w\-]+',
            \ 'complete_pattern': ':\s*',
            \ 'on_complete': ['ncm2#oncomplete#omni', 'csscomplete#CompleteCSS'],
            \ })

" ================
" Language Servers
" ================
let g:LanguageClient_serverCommands = {
            \ 'javascript': ['/home/yel/.nvm/versions/node/v12.4.0/bin/javascript-typescript-stdio'],
            \ 'typescript': ['/home/yel/.nvm/versions/node/v12.4.0/bin/javascript-typescript-stdio'],
            \ 'python': ['/usr/bin/pyls'],
            \ 'rust': ['/usr/bin/rustup', 'run', 'stable', 'rls'],
            \ 'docker': ['/home/yel/.nvm/versions/node/v12.4.0/bin/docker-langserver', '--stdio'],
            \ 'vim': ['/home/yel/.nvm/versions/node/v12.4.0/bin/vim-language-server', '--stdio']
            \ }

" ===============
" Editor settings
" ===============
filetype plugin indent on
set autoindent
set encoding=utf-8
set relativenumber
set number
set laststatus=2
set colorcolumn=120
set mouse=a
set showcmd
set hidden

" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=iwhite " No whitespace in vimdiff
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

set wildmenu

set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

set incsearch
set ignorecase
set smartcase
set gdefault

" ============
" GUI Settings
" ============
set ruler
set ttyfast
set nolist
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" FZF
map <c-p> :FZF<cr>
noremap <leader>s :Rg<cr>
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

function! s:list_cmd()
    let base = fnamemodify(expand('%'), ':h:.:S')
    return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
            \                               'options': '--tiebreak=index'}, <bang>0)

nnoremap <c-left> :bp<CR>
nnoremap <c-right> :bn<CR>
nnoremap <s-left> :tabp<CR>
nnoremap <s-right> :tabn<CR>

nnoremap j gj
nnoremap k gk

nnoremap <leader>= :'<, '>RustFmtRange<cr>

" Jump to last edit position on opening file
if has("autocmd")
    " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
    au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd BufRead *.md set filetype=markdown

" NERDCommenter
nmap <C-_>	<Plug>NERDCommenterToggle
vmap <C-_>	<Plug>NERDCommenterToggle<CR>gv

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

let g:ft = ''
function! NERDCommenter_before()
    if &ft == 'vue'
        let g:ft = 'vue'
        let stack = synstack(line('.'), col('.'))
        if len(stack) > 0
            let syn = synIDattr((stack)[0], 'name')
            if len(syn) > 0
                exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
            endif
        endif
    endif
endfunction
function! NERDCommenter_after()
    if g:ft == 'vue'
        setf vue
        let g:ft = ''
    endif
endfunction

" NERDTree
let NERDTreeShowHidden = 1
map <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ 'Ignored'   : '☒',
            \ "Unknown"   : "?"
            \ }

" vim: ft=vim
