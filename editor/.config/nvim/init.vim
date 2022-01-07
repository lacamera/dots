set nocompatible
filetype off


call plug#begin()
	" vim enhancements
	Plug 'ciaranm/securemodelines'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'justinmk/vim-sneak'

	" gui enhancements
	Plug 'itchyny/lightline.vim'
	Plug 'machakann/vim-highlightedyank'
	Plug 'chriskempson/base16-vim'

	" fuzzy finder
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

	" semantic language support
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/lsp_extensions.nvim'
	Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
	Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
	Plug 'hrsh7th/cmp-path', {'branch': 'main'}
	Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
	Plug 'ray-x/lsp_signature.nvim'

	" only because nvim-cmp _requires_ snippets
	Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
	Plug 'hrsh7th/vim-vsnip'

	" syntactic language support
	Plug 'lervag/vimtex'
	Plug 'cespare/vim-toml'
	Plug 'stephpy/vim-yaml'
	Plug 'rust-lang/rust.vim'
	Plug 'rhysd/vim-clang-format'
	Plug 'fatih/vim-go'
	Plug 'godlygeek/tabular'
	Plug 'plasticboy/vim-markdown'
call plug#end()


if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end


" colors 
if !has('gui_running')
  set t_Co=256
endif
if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  set termguicolors
endif
set background=dark
let base16colorspace=256
colorscheme base16-gruvbox-dark-hard
syntax on
hi Normal ctermbg=NONE


" built-in lsp configuration
lua << END
local cmp = require'cmp'
local lspconfig = require'lspconfig'

cmp.setup({
  snippet = {
    -- TODO: REQUIRED by nvim-cmp
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = {['<Tab>'] = cmp.mapping.confirm({ select = true })},
  sources = cmp.config.sources(
    -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
	{{ name = 'nvim_lsp' }}, {{ name = 'path' }}
  ),
  experimental = { ghost_text = true }
})

-- enable completing paths in:
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

-- plugin: lspconfig
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- mappings
  local opts = { noremap=true, silent=true }

  -- see `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- get signatures (and _only_ signatures) when in argument lists
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = { border = "none" }
  })
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- lang: Rust
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  flags = { debounce_text_changes = 150 },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      completion = {
		postfix = { enable = false },
      },
    },
  },
  capabilities = capabilities
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
END


" enable type inlay hints
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }


" plugin: securemodelines
let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]


" plugin: lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ },
      \ }


" plugin: lightline
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction


" lang_ JavaScript
let javaScript_fold=0


" lang: LaTeX
let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []


" lang: Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'


" lang: Go
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
" let g:go_bin_path = expand("~/go/bin")


" completion
" menuone: popup even when there's only one match
" noinsert: do not insert text until a selection is made
" noselect: do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
set cmdheight=2
set updatetime=300


" general
filetype plugin indent on
set autoindent
set timeoutlen=300
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
set signcolumn=yes
set exrc
set secure


" sane splits
set splitright
set splitbelow


" permanent undo
set undodir=~/.vimdid
set undofile


" decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor


" tabs
set shiftwidth=4
set softtabstop=4
set tabstop=4
set noexpandtab


" wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines


" search
set incsearch
set ignorecase
set smartcase
set gdefault
set guioptions-=T	" remove toolbar
set vb t_vb=		" no more beeps
set backspace=2		" backspace over newlines
set nofoldenable
set ttyfast
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber	" relative line numbers
set number			" also show current absolute line
set showcmd			" show (partial) command in status line.
set mouse=a			" enable mouse usage (all modes) in terminals
set shortmess+=c	" don't give |ins-completion-menu| messages.


" diff
set diffopt+=iwhite
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic


" special characters
" verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set listchars=nbsp:¬,extends:»,precedes:«,trail:•


let mapleader = "\<Space>"
" no arrow keys
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
map H ^
map L $
" ,p will paste clipboard into buffer
noremap <leader>p :read !xsel --clipboard --output<cr>
" ,c will copy entire buffer into clipboard
noremap <leader>c :w !xsel -ib<cr><cr>
" open new file adjacent to current file
nnoremap <leader>o :e <C-R>=expand("%:p:h") . "/" <CR>
" left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>
" move by line
nnoremap j gj
nnoremap k gk
" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>
" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>
" <leader>q shows stats
nnoremap <leader>q g<c-g>
" unbind F1 (:help)
map <F1> <Esc>
imap <F1> <Esc>


" leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste


" jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" help filetype detection
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.lds set filetype=ld
autocmd BufRead *.tex set filetype=tex
autocmd BufRead *.trm set filetype=c
