set nocompatible
filetype off

call plug#begin()

	Plug 'ciaranm/securemodelines'
	Plug 'yggdroot/indentline'
	Plug 'godlygeek/tabular'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'justinmk/vim-sneak'
	Plug 'ervandew/supertab'
	Plug 'junegunn/fzf', { 'dir': '~/.local/share/fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

	Plug 'base16-project/base16-vim'
	Plug 'itchyny/lightline.vim'
	Plug 'mengelbrecht/lightline-bufferline'
	Plug 'mike-hearn/base16-vim-lightline'
	Plug 'ninjin/vim-openbsd'

	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/lsp_extensions.nvim'
	Plug 'ray-x/lsp_signature.nvim'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'

	Plug 'lervag/vimtex'
	Plug 'cespare/vim-toml'
	Plug 'stephpy/vim-yaml'
	Plug 'rust-lang/rust.vim'
	Plug 'rhysd/vim-clang-format'
	Plug 'fatih/vim-go'
	Plug 'plasticboy/vim-markdown'
	Plug 'elzr/vim-json'
	Plug 'neovimhaskell/haskell-vim'
	Plug 'vim-perl/vim-perl'
call plug#end()

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set inccommand=nosplit

set t_Co=256
let base16colorspace=256
set termguicolors
set background=dark
colorscheme base16-classic-dark
syntax on

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_python_provider = 0
let g:loaded_node_provider = 0

lua << END
local cmp = require'cmp'
local lspconfig = require'lspconfig'

--require("godbolt").setup({
--    languages = {
--        c = { compiler = "cg121", options = {} },
--        cpp = { compiler = "g121", options = {} },
--        rust = { compiler = "r1600", options = {} },
--        -- any_additional_filetype = { compiler = ..., options = ... },
--    },
--    quickfix = {
--        enable = false, -- whether to populate the quickfix list in case of errors
--        auto_open = false -- whether to open the quickfix list in case of errors
--    },
--    url = "https://godbolt.org" -- can be changed to a different godbolt instance
--})

--require("clangd_extensions").setup{}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = {['<Tab>'] = cmp.mapping.confirm({ select = true })},
  sources = cmp.config.sources(
	{{ name = 'nvim_lsp' }}, {{ name = 'path' }}
  ),
  experimental = { ghost_text = true },
  sorting = {
    comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        --require("clangd_extensions.cmp_scores"),
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
        },
    },
})

-- enable completing paths in:
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
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

lspconfig.gopls.setup{}
lspconfig.pylsp.setup{}

-- git clone https://github.com/haskell/haskell-language-server
-- cd haskell-language-server && cabal install
-- lspconfig.hls.setup{}

lspconfig.clangd.setup { cmd={ "clangd", "--background-index" } }

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      completion = { postfix = { enable = false } },
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

autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

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

let g:lightline = {
	  \ 'colorscheme': 'base16_classic_dark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ }
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

let javaScript_fold=0
let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclipboard -selection clipboard'
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 0
let g:go_bin_path = expand("$HOME/go/bin")
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1

filetype plugin indent on
set completeopt=menuone,noinsert,noselect
set cmdheight=1
set updatetime=240
set clipboard+=unnamedplus
set autoindent
set timeoutlen=180
set encoding=utf-8
set printencoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
set signcolumn=yes
set exrc
set secure
set splitright
set splitbelow
set undodir=~/.vimdid
set undofile
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor
set shiftwidth=4
set softtabstop=4
set tabstop=4
set noexpandtab
set formatoptions=tc
set formatoptions+=r
set formatoptions+=q
set formatoptions+=n
set formatoptions+=b
set incsearch
set ignorecase
set smartcase
set gdefault
set guioptions-=T
set vb t_vb=
set backspace=2
set nofoldenable
set ttyfast
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber
set number
set showcmd
set mouse=a
set shortmess+=c

set diffopt+=iwhite
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

" verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•

let mapleader = "\<Space>"

nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

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

autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.tex set filetype=tex
autocmd BufRead *.h set filetype=c

" jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

